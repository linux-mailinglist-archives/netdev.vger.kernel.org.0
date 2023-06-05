Return-Path: <netdev+bounces-8140-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9988C722E61
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:11:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C13121C20C58
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9BA2262A;
	Mon,  5 Jun 2023 18:11:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33074AD2E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:11:42 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D31D2
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685988700; x=1717524700;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=k6jzT4yI+gRc6sTxaQUpMyiH2+91F1lvQ5rs+JyD8nQ=;
  b=k2LosacmiLTof2aJlbkq5mtkQVvC21bHT3/XnZQ+ZzhTReMyxxU4XfBa
   xVq1FjWj+aUfoFijqu4uM37ZPNeON3itwXJSAXaGBB8xJWLhe84yDDabs
   VGWAtTea5bowT0w5tImbMvGVriGeJ2C6peBBqkgAhye35P75WDpzacpYn
   6fdl0m43Knj2moQQ1fvXr689KV8Lad6V8U9MFWGRmdQPQb/gV5CWnHK6z
   wP0R8ibQ26iim6bRrGpcXGJRY/EkOOhjgqpR5ayzzhKrEWOYohdrpTMq6
   +WWa6HBjwpnwIYgtwo0KQTmk6nsR7AYxLLL4eLrNw0Sz0xiWh3BOPky1/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="355294146"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="355294146"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 11:11:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="659179381"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="659179381"
Received: from skondoju-mobl.ccr.corp.intel.com (HELO vcostago-mobl3) ([10.212.219.207])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 11:11:39 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>, Tony Nguyen
 <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, sasha.neftin@intel.com,
 richardcochran@gmail.com, Kurt Kanzenbach <kurt@linutronix.de>, Naama Meir
 <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net 3/4] igc: Retrieve TX timestamp during interrupt
 handling
In-Reply-To: <20230605-distort-jab-ce1f3ece058a-mkl@pengutronix.de>
References: <20230530174928.2516291-1-anthony.l.nguyen@intel.com>
 <20230530174928.2516291-4-anthony.l.nguyen@intel.com>
 <20230605-distort-jab-ce1f3ece058a-mkl@pengutronix.de>
Date: Mon, 05 Jun 2023 11:11:38 -0700
Message-ID: <87cz29srs5.fsf@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Marc Kleine-Budde <mkl@pengutronix.de> writes:

> On 30.05.2023 10:49:27, Tony Nguyen wrote:
>> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>>=20
>> When the interrupt is handled, the TXTT_0 bit in the TSYNCTXCTL
>> register should already be set and the timestamp value already loaded
>> in the appropriate register.
>>=20
>> This simplifies the handling, and reduces the latency for retrieving
>> the TX timestamp, which increase the amount of TX timestamps that can
>> be handled in a given time period.
>
> What about renaming the igc_ptp_tx_work() function, as it's not
> scheduled work anymore, also IMHO you should update the function's
> comment.

Will rename the function and fix the comment for v2. Thanks.

>
> Marc
>
> --=20
> Pengutronix e.K.                 | Marc Kleine-Budde          |
> Embedded Linux                   | https://www.pengutronix.de |
> Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |


Cheers,
--=20
Vinicius

