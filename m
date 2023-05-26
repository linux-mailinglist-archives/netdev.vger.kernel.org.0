Return-Path: <netdev+bounces-5785-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D32B8712BD7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 891151C21031
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6369428C39;
	Fri, 26 May 2023 17:35:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5800528C34
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:35:28 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E519CA4;
	Fri, 26 May 2023 10:35:26 -0700 (PDT)
Received: from [10.10.2.69] (unknown [10.10.2.69])
	by mail.ispras.ru (Postfix) with ESMTPSA id 25D1144C1026;
	Fri, 26 May 2023 17:35:25 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 25D1144C1026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1685122525;
	bh=dYeLF47soPl7A+3mco/KP4CbNt6s64UADpsf1OpQymM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pVeC0NSqyg0BQdlFdDE7MRCx9srs21kp9uSABHpC+mn3dAYyafLGtt/eD76tf+2Cc
	 GkzTa70/deJoETlL7/UJCZXxzSQB+7co8if99rWDXJD4aCK3oJu7c5W7LBs0HHDBQx
	 g5rpo9OEg2lALO1J/ndZkhVMg1Mpxn+mNxWXoOpY=
Message-ID: <09834e8d-ca48-e21d-fd96-9de87294a7f4@ispras.ru>
Date: Fri, 26 May 2023 20:35:25 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] batman-adv: Broken sync while rescheduling delayed work
Content-Language: ru
To: Sven Eckelmann <sven@narfation.org>,
 Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
 Antonio Quartulli <a@unstable.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, b.a.t.m.a.n@lists.open-mesh.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
References: <20230526161632.1460753-1-VEfanov@ispras.ru>
 <5834562.MhkbZ0Pkbq@bentobox>
From: Vlad Efanov <vefanov@ispras.ru>
In-Reply-To: <5834562.MhkbZ0Pkbq@bentobox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Sven,


cancel_delayed_work_sync() and queue_delayed_work()

use WORK_STRUCT_PENDING_BIT in work->data to synchronize.

INIT_DELAYED_WORK() clears this bit.


The situation is :  __cancel_work_timer() sets WORK_STRUCT_PENDING_BIT

but INIT_DELAYED_WORK() in batadv_dat_start_timer() clears it

and queue_delayed_work() schedules new work.


Best regards,

Vlad.

On 26.05.2023 19:49, Sven Eckelmann wrote:
> On Friday, 26 May 2023 18:16:32 CEST Vladislav Efanov wrote:
>> The reason for these issues is the lack of synchronization. Delayed
>> work (batadv_dat_purge) schedules new timer/work while the device
>> is being deleted. As the result new timer/delayed work is set after
>> cancel_delayed_work_sync() was called. So after the device is freed
>> the timer list contains pointer to already freed memory.
> You are most likely right but could you please point out what in the worker is
> checked by the workqueue code that prevents it from being scheduled again?
> (and which seems to be overwritten as your patch seems to suggest)
>
> I think __cancel_work_timer marked the work as canceling but
> batadv_dat_start_timer reinitialized the worked (thus removing this important
> state). Would be nice if you could either correct me or confirm what I think to
> remember.
>
> Kind regards,
> 	Sven

