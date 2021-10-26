Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3986343B0E0
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 13:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhJZLSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 07:18:47 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58388 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbhJZLSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 07:18:43 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C33002195A;
        Tue, 26 Oct 2021 11:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635246978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4TUIh5Eni3UuUMatcRqaWFQe8wo5puFtctQX6IG3hRY=;
        b=X/+rMvfe35p8h8J8Io1vIjFHbA3U5uEgjDElZFEJL8hv2cEcmw3nEW1GH2MqFMFEhLRp43
        ooJq4jxxKb1dEVLVSRBUr2zv6zrcGzgaXc71L29ByqeX6vvlRjFnmsom31f2B2u1GMInFH
        jLc/bdKbXItDycCj6bu3ggnY6CUw+nc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635246978;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4TUIh5Eni3UuUMatcRqaWFQe8wo5puFtctQX6IG3hRY=;
        b=43ZcY4iD3hvqvM8bKmAPeS38RLGfXIks1vjQ6jIm20VX6Avi7cVvevoEfUnSBbZaIvid36
        CYBOvehvZlTAWOAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 857AE13CFD;
        Tue, 26 Oct 2021 11:16:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dqLyHIHjd2H/LwAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Tue, 26 Oct 2021 11:16:17 +0000
Subject: Re: [PATCH net-next v3] net: sched: gred: dynamically allocate
 tc_gred_qopt_offload
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20211026100711.nalhttf6mbe6sudx@linutronix.de>
 <3bf1e148-14fc-98f6-5319-78046a7b9565@suse.de>
 <20211026105104.vhfxrwisqcbvsxiq@linutronix.de>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <d3a32766-550c-11a1-4364-98f876e7ce12@suse.de>
Date:   Tue, 26 Oct 2021 14:16:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211026105104.vhfxrwisqcbvsxiq@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



10/26/21 1:51 PM, Sebastian Andrzej Siewior пишет:
> On 2021-10-26 13:42:24 [+0300], Denis Kirjanov wrote:
>>> diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
>>> index 72de08ef8335e..1073c76d05c45 100644
>>> --- a/net/sched/sch_gred.c
>>> +++ b/net/sched/sch_gred.c
>>> @@ -311,42 +312,43 @@ static void gred_offload(struct Qdisc *sch, enum tc_gred_command command)
>>>    {
>>>    	struct gred_sched *table = qdisc_priv(sch);
>>>    	struct net_device *dev = qdisc_dev(sch);
>>> -	struct tc_gred_qopt_offload opt = {
>>> -		.command	= command,
>>> -		.handle		= sch->handle,
>>> -		.parent		= sch->parent,
>>> -	};
>>> +	struct tc_gred_qopt_offload *opt = table->opt;
>>>    	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
>>>    		return;
>>> +	memset(opt, 0, sizeof(*opt));
>>
>> It's zeroed in kzalloc()
> 
> but it is not limited to a single invocation?

I meant that all fields are set in the function as it was with the stack 
storage.

> 
> Sebastian
> 
