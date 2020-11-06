Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DAF2A994A
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 17:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgKFQRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 11:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbgKFQRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 11:17:18 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73972C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 08:17:16 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id p1so1875664wrf.12
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 08:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fc1sSmAvWcSw7mgK9PzbvDNnj1DKq7i0rcvlvMAKsXE=;
        b=LeA7xfrOsL2/EtYpgOlZJbBcINZIxJsFCNaRYLhwotDeKBrrQV0W5ZAIQMu9q4S20w
         xkMr+ZB7o2z4q6kEftSYOzP9+6s71iAMpwosWRFJ9rnL4yt06MtCc7eAuLTUI5eo9Yf6
         m/jGp8WlHbBK+E8EzbwNrBPDe3wMTKVKmqQ9qWLdz03eyuU+vq/sQ019H9cXUBT7eJjM
         jX2kjfQDUjzvHJ/8s+rMrBJhn31plJysb3/dskItZleAq0FrmqRQKV2+iVYY3w3jmHLj
         51o5/Ps1AnvTK3xGb0Uf+63snv2oeO/mMViZIkB7RGLUv1mdV6G1HGys1OC4kG0diI+r
         bxTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fc1sSmAvWcSw7mgK9PzbvDNnj1DKq7i0rcvlvMAKsXE=;
        b=gqNjo51C+xh0MkOoM/T1EYt27joQ6Wze5Y2HQJk4rlHqxLzTOeKausyp3S0cyONfrV
         WXyNYxhGJ5YHW+yGw/KGEKp/HrBpao1ryBjfm2hozoLmVAdJKzUbCzl/e2YRgM/TX4y5
         TnI9ZBreLQEUhlFGi0yfetgWqwEXXN7ecuUGoXjsDpvBdXBz4SeFeEnAKyJ4p1uZmXZr
         YBox/wgrf2CM+Le2MbxJdRfqaEhp6DmCTSTP6/cYs2LW5ivyiwWo/dVMhnwjYMBq6hBR
         iQ/TthZHyts1UJHK+Q1HH2P0M+edhLDAXNgztrKaAXNeRpDCpVlQ368eBT2AgG1p5p8X
         bwKw==
X-Gm-Message-State: AOAM531WYVcSrFXJVlnO3ueDUXaZMAAwNcRFwR5x3GtFmmC6lbBv+QCG
        mqnOCXArT0QHL26xG33sunY=
X-Google-Smtp-Source: ABdhPJxqiPeeYU14SHMQeTqimJXKYq0LfRsNqDPGzymPFbc8P/5ulmbQJmYRxRzcW5kwswx0Z5o8Yw==
X-Received: by 2002:adf:a343:: with SMTP id d3mr3500217wrb.91.1604679434721;
        Fri, 06 Nov 2020 08:17:14 -0800 (PST)
Received: from [192.168.8.114] ([37.170.181.66])
        by smtp.gmail.com with ESMTPSA id l16sm2763485wrx.5.2020.11.06.08.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 08:17:13 -0800 (PST)
Subject: Re: [RESEND PATCH] bonding: wait for sysfs kobject destruction before
 freeing struct slave
To:     Jamie Iles <jamie@nuviainc.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
References: <20201105084108.3432509-1-jamie@nuviainc.com>
 <89416a2d-8a9b-f225-3c2a-16210df25e61@gmail.com>
 <20201105181108.GA2360@poplar>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d4b96330-4ee1-6393-1096-03a06abd3889@gmail.com>
Date:   Fri, 6 Nov 2020 17:17:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201105181108.GA2360@poplar>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/5/20 7:11 PM, Jamie Iles wrote:
> Hi Eric,
> 
> On Thu, Nov 05, 2020 at 01:49:03PM +0100, Eric Dumazet wrote:
>> On 11/5/20 9:41 AM, Jamie Iles wrote:
>>> syzkaller found that with CONFIG_DEBUG_KOBJECT_RELEASE=y, releasing a
>>> struct slave device could result in the following splat:
>>>
>>>
>>
>>> This is a potential use-after-free if the sysfs nodes are being accessed
>>> whilst removing the struct slave, so wait for the object destruction to
>>> complete before freeing the struct slave itself.
>>>
>>> Fixes: 07699f9a7c8d ("bonding: add sysfs /slave dir for bond slave devices.")
>>> Fixes: a068aab42258 ("bonding: Fix reference count leak in bond_sysfs_slave_add.")
>>> Cc: Qiushi Wu <wu000273@umn.edu>
>>> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>>> Cc: Veaceslav Falico <vfalico@gmail.com>
>>> Cc: Andy Gospodarek <andy@greyhouse.net>
>>> Signed-off-by: Jamie Iles <jamie@nuviainc.com>
>>> ---
> ...
>> This seems weird, are we going to wait for a completion while RTNL is held ?
>> I am pretty sure this could be exploited by malicious user/syzbot.
>>
>> The .release() handler could instead perform a refcounted
>> bond_free_slave() action.
> 
> Okay, so were you thinking along the lines of this moving the lifetime 
> of the slave to the kobject?
> 

This seems a bit too complex for a bug fix.

Instead of adding a completion, you could add a refcount_t, and
make bond_free_slave() a wrapper like

static inline void bond_free_slave(struct slave *slave)
{
   if (refcount_dec_and_test(&slave->refcnt))
       __bond_free_slave(slave);
}

Once the kobj is successfully activated, you would
need a refcount_inc(&slave->refcount);

Total patch would be smaller and easier to review.

The kobj .release handler would simply call bond_free_slave(slave);



