Return-Path: <netdev+bounces-7521-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B677208AD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:56:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53CA1281A27
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57CAA18014;
	Fri,  2 Jun 2023 17:56:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E2B332F8
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 17:56:50 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCBF133
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685728608; x=1717264608;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=wbAui8TcVoPFK+AlyYWEiRDm3E9HPBtI/plFjzGzqy0=;
  b=Fyv5eIxywg2Wa+RWVv4zgNZuIRLZXlqwSykIe9/P+8N4/uzm3AJAhZVI
   XVH/8S/1dyETFycKoNCSClgJIbVrETw1bS2B8DG7J3r57HkD8VhQpsCL+
   RhkNbDAJGDoobS+EE6wZ/EI4b9XRy9Cwd6RCtyrPvPnmSJpQOpnSvlAis
   9Zb2axBBUL4cV1ILB8zD3QNqKO/N21OrzXmm/S3+t1anj0OyMm5ZoFZ7k
   Z5kOoH8zLw5MiKJ8iayXAp/hZ2egAIxoeCZ4neQEwi+JlZxXUNdVTQ54G
   tu31YvSO6O6CA0egxpLSeu40H9FshUDqj6UvJerZWUe8khMPJUkwKDw+k
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="355938893"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="355938893"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 10:56:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="832056163"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="832056163"
Received: from bzhang2-mobl2.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.148.245])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 10:56:41 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
 sasha.neftin@intel.com, richardcochran@gmail.com, Vladimir Oltean
 <vladimir.oltean@nxp.com>, Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net 2/4] igc: Check if hardware TX timestamping is
 enabled earlier
In-Reply-To: <20230601205516.7322d9e3@kernel.org>
References: <20230530174928.2516291-1-anthony.l.nguyen@intel.com>
 <20230530174928.2516291-3-anthony.l.nguyen@intel.com>
 <20230531231029.36822957@kernel.org> <87353aubds.fsf@intel.com>
 <20230601205516.7322d9e3@kernel.org>
Date: Fri, 02 Jun 2023 10:56:40 -0700
Message-ID: <87ttvpsq7b.fsf@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 01 Jun 2023 14:21:35 -0700 Vinicius Costa Gomes wrote:
>> > AFAICT the cancel / cleanup path is not synchronized (I mean for
>> > accesses to adapter->tstamp_config) so this looks racy to me :(
>> 
>> As far as I can see, the racy behavior wasn't introduced here, can I
>> propose the fix as a follow up patch? Or do you prefer that I re-spin
>> this series?
>
> I think respin would be better, you're rejigging the synchronization
> here, who knows if you won't have to rejig differently to cover this
> case.

Makes sense. Will do that.


Cheers,
-- 
Vinicius

