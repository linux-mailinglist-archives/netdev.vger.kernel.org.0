Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8210C7229C
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389655AbfGWWuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:50:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44693 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732011AbfGWWuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:50:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id i18so20136062pgl.11
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 15:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=pHw3Ee5nMVwvj1/SebyVAUT9rUoqdm8uOCNTdDZJkLk=;
        b=kGta9NVyf4DtWP5KtQuflJKE/5xK+8yYhyUz6a+C6dZSLAzozfqKIcbU6tS2gvez2G
         G/WUglvl7+WlGDNmO81AGCypjTY7Ld8M3g+r0m/5uxRiFTk2zRU5sueRV3TKQjlc2Cxg
         HVFOGjiN54Cxg+joZ77BPCQgyLgooVlv/C8lxY4n2nlSInIVAp/iUN/L+bvoKZHY9kzP
         JsZp546zk9Aj358vwdoArGmABhuSo644XAjpnogIqre0jbsRCa2d4XHHIuthWay9tRBP
         iITJqSnY/p+AqwaNri4xWLcW0otAq9GhFUYIp1CO5oNUAxG+71E3Gh7YjHmywbQCEGrd
         438A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pHw3Ee5nMVwvj1/SebyVAUT9rUoqdm8uOCNTdDZJkLk=;
        b=oYSEq2kTXj0c6OtqyaktKWxP19gXv/5VZNStjFVQ5QTXtvGdiPvBOT4oG/vuVKF41x
         uqVYT6d/gWzwHQp8oTW4/6cFA5Ue1U0TraKgMMQdf2RMGzmeq8Z30jWNZL4XRjMuvV2B
         ZQGtuZi+ghcPF8OKaYT2Fp57Qi9JPoJ23NVfA7EmegXLfSLlcJbZqaRp9ejiZwsDqvdb
         +SsKHg/ycsmJeXoFLuiWhqjssRL9wcTsP0csiC6EMgFfljmTBFB4oabptbm4o5IYOcZQ
         Kc2z0fksePwrr1V9mXf8jmSVVXKOz9YWVCRJvUkdvDyMqZPE5wyKSSzY1O9+fM0LIoWM
         dmvQ==
X-Gm-Message-State: APjAAAVN9O9fanvc4LXlYQU+ya+vh6ql2CGlxX4SNuqQd616MecClP3I
        5GqyVaV+9q53OO0hstNeGUARDloJ+Yg0Sw==
X-Google-Smtp-Source: APXvYqypR8kJewmqknRKF+ecx9HHNKzxqWKzeCwYZmPQ3wdixHDemp1UVU/RKpBuorJQiSh2gc4gUw==
X-Received: by 2002:a63:5920:: with SMTP id n32mr75887134pgb.352.1563922245098;
        Tue, 23 Jul 2019 15:50:45 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p13sm114205541pjb.30.2019.07.23.15.50.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:50:44 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 11/19] ionic: Add Rx filter and rx_mode ndo
 support
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-12-snelson@pensando.io>
 <20190723.143326.197667027838462669.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <e0c8417c-75bf-837f-01b5-60df302dafa7@pensando.io>
Date:   Tue, 23 Jul 2019 15:50:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723.143326.197667027838462669.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 2:33 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Mon, 22 Jul 2019 14:40:15 -0700
>
>> +	if (in_interrupt()) {
>> +		work = kzalloc(sizeof(*work), GFP_ATOMIC);
>> +		if (!work) {
>> +			netdev_err(lif->netdev, "%s OOM\n", __func__);
>> +			return -ENOMEM;
>> +		}
>> +		work->type = add ? DW_TYPE_RX_ADDR_ADD : DW_TYPE_RX_ADDR_DEL;
>> +		memcpy(work->addr, addr, ETH_ALEN);
>> +		netdev_dbg(lif->netdev, "deferred: rx_filter %s %pM\n",
>> +			   add ? "add" : "del", addr);
>> +		ionic_lif_deferred_enqueue(&lif->deferred, work);
>> +	} else {
>> +		netdev_dbg(lif->netdev, "rx_filter %s %pM\n",
>> +			   add ? "add" : "del", addr);
>> +		if (add)
>> +			return ionic_lif_addr_add(lif, addr);
>> +		else
>> +			return ionic_lif_addr_del(lif, addr);
>> +	}
> I don't know about this.
>
> Generally interface address changes are expected to be synchronous.
Yeah, this bothers me a bit as well, but the address change calls come 
in under spin_lock_bh(), and I'm reluctant to make an AdminQ call under 
the _bh that could block for a few seconds.

sln

