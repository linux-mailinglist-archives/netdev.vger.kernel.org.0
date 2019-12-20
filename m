Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D30127AC3
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 13:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfLTMLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 07:11:25 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44898 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbfLTMLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 07:11:25 -0500
Received: by mail-io1-f68.google.com with SMTP id b10so9144798iof.11
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 04:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sjoBVnmN1fJq8TKBI+4jCTQTzvqpyaugxsFul1V9WbY=;
        b=k2/lEEhXS40JjR2uz1vIPNQIv80obzYjUOs867XNiCiP3m2OZZ6w4sivH0pO/Vara2
         OKP01AHhiCNf0UgCoE2+05ohZ+lIY38XXoTkbL7EVQ4cYsc217qEewSA+oARGLDThdLe
         P9FpfkHxdsyBGyibkBkO2+reytvKc+ct1w69hsDy9UfwUzDXiQYEQxP+YE20NKH5V4DE
         9q11JVImJM2mfbjiBgCeov59UW3uLMhsCvM/9tS/1SZoAvJLv+R+qrqUPGTimYBFIKmZ
         wQ2uiYPKuCCSCYc64vxXPfzjdXj7nCkMXJzgXKJnWcx7k4hcEAPleR3XDSqdFcV8QndR
         MLcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sjoBVnmN1fJq8TKBI+4jCTQTzvqpyaugxsFul1V9WbY=;
        b=OA6tvp9zn4KFV+t2T3O6OCP1yBSbQx02gVYHUkfwiWklK4gX/upq0rf6fJqZou8hiI
         8SkslbdsgO9uiWyPAVL3i9Di9QxECRRl/BB4d5sETG5UoP7wKwgLP03HmvSEV0vk1rCQ
         5/sVo3OeOJGS3HH7PJtj+KUBL3d8LTpifMGNQcCwqISJzBs9z9qz8xmT0CKt8vNDwG+L
         d+ZfQBFzN3yIcESfLEoljHgL5vp+c4zAh86pnPhmwuGc/vnCR6VIfvTFZ7DwKQeEuq0W
         xY3uohSYpmKQcE4u32iSengkdn+IwLPivmi7b7CeIAWXZCoxQN4nZQ986dIizNDgBUSr
         O6uQ==
X-Gm-Message-State: APjAAAUd9JKkMC6sDTSRl7kdhx25skSd0ZOGIyTUaiWESfNf//1Pha2P
        rsCWNHXynQXkPhAxSZfUd4vKGA==
X-Google-Smtp-Source: APXvYqyYJBTNLgvpaToHG+zW5whpfAfdAhlu+NiF2tCN9V4F8W7r9GE7XvylUYwEjP5RdW3yur6sHA==
X-Received: by 2002:a6b:6f06:: with SMTP id k6mr9997133ioc.204.1576843884643;
        Fri, 20 Dec 2019 04:11:24 -0800 (PST)
Received: from [192.168.0.125] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id z21sm3206375ioj.21.2019.12.20.04.11.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 04:11:23 -0800 (PST)
Subject: Re: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Roman Mashak <mrv@mojatatu.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
 <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
 <bafb52ff-1ced-91a4-05d0-07d3fdc4f3e4@mojatatu.com>
 <5b4239e5-6533-9f23-7a38-0ee4f6acbfe9@mojatatu.com>
 <vbfr2102swb.fsf@mellanox.com>
 <63fe479d-51cd-eff4-eb13-f0211f694366@mojatatu.com>
 <vbfpngk2r9a.fsf@mellanox.com> <vbfo8w42qt2.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <b9b2261a-5a35-fdf7-79b5-9d644e3ed097@mojatatu.com>
Date:   Fri, 20 Dec 2019 07:11:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <vbfo8w42qt2.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-19 12:01 p.m., Vlad Buslov wrote:

> 
> BTW another approach would be to extend ops with new callback
> delete_empty(), require unlocked implementation to define it and move
> functionality of tcf_proto_check_delete() there. Such approach would
> remove the need for (ab)using ops->walk() for this since internally
> in classifier implementation there is always a way to correctly verify
> that classifier instance is empty. Don't know which approach is better
> in this case.

I see both as complementing each other. delete_empty()
could serves like guidance almost for someone who wants to implement
parallelization (and stops abuse of walk()) and
TCF_PROTO_OPS_DOIT_UNLOCKED is more of a shortcut. IOW, you
could at the top of tcf_proto_check_delete() return true
if TCF_PROTO_OPS_DOIT_UNLOCKED is set while still invoking
delete_empty() (instead of walk()) if you go past that.
Would that work?

cheers,
jamal

