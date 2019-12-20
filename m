Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67866127ED5
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 15:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfLTO5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 09:57:22 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33850 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfLTO5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 09:57:22 -0500
Received: by mail-io1-f65.google.com with SMTP id z193so9655838iof.1
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 06:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WFNYclONl/6HL6k2EKzdgJHFo848QlaxuQALW2SRASY=;
        b=cR5kztBfOym7/ifY/GEgBDVKueHwr+5gJBNOFula1fu0/39dvhVenzv477hdhe1SEV
         jG2yG2/qm2W6c2FN8OezrzNweq0UnIlzSxR5VkMOg9hA4X7yRdP8m5uR8gPKZi+zsGxj
         knNVWBepyfwEHbcHobMC0b6LChY/zHefyd7pE3jC4yGwbYcysypR40zeE1QwwYaYDLAV
         IwD8mxbUn6H9TgNFl2Q8tcaOc4I/bnFsFTJPL+a6bY5GS5C9ycghjq+CZ1hoqegtV899
         r98BCfsnd28jRy5ZXZD7RN5rDgKKkKnz77F6U3I+TVyxtmF4oGgFO51POa3mA5GHAvQb
         hZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WFNYclONl/6HL6k2EKzdgJHFo848QlaxuQALW2SRASY=;
        b=sqlfyoUmQEvS/gbIZuy/fCrGJ0Qu0Dtd9npl/LavFBRrkZDw3zu+HJgZe3FuCEY8vg
         l9REEKWx+xl1RmD1ZofckORcsuKq+8yQph/G5T3j02BVZ28FawB0EIMTKSBmrFssJCgx
         Xv1MDcM9XCMvdenxTWbGPZ1DmVFFcLdHfhzx6NfrxCfwKhJrgqCNVmwykZpEtxR260lE
         DtO+R92GLtzYaD1gITw+xAUCrAaHvP4RLs1IJwj/nA/rqdIP86xSiSIp3JV6fd7xy1Re
         cfWoHf2XkZqVgApvXsa8lPOVHF36Tu7FKuZsLqAFyHFWLXyd9THbY+8x3eqMU6wAy83k
         7Rhw==
X-Gm-Message-State: APjAAAWQ5fesK0lnm4jJfnEbSdyUpIRuIiCdCbmQMomZN3K1NYXrp6LX
        7AdPtt5amfpE8TQeBdhXdzAXtmjPiEU=
X-Google-Smtp-Source: APXvYqwcGJIhJO9xQLn7q8EeCLkMHzLujIN8UTsfGoCUuWUTG/6hR6dC2IvEfGfReWLkmvv3KeHIoA==
X-Received: by 2002:a5e:c314:: with SMTP id a20mr10663601iok.300.1576853841550;
        Fri, 20 Dec 2019 06:57:21 -0800 (PST)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id v10sm3360087iot.12.2019.12.20.06.57.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 06:57:20 -0800 (PST)
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
 <b9b2261a-5a35-fdf7-79b5-9d644e3ed097@mojatatu.com>
 <548e3ae8-6db8-a45c-2d9c-0e4a09dc737b@mojatatu.com>
 <cc0a3849-48c0-384d-6dd5-29a6763695f2@mojatatu.com>
 <vbfa77n2iv8.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <02026181-9a29-2325-b906-7b4b2af883a2@mojatatu.com>
Date:   Fri, 20 Dec 2019 09:57:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <vbfa77n2iv8.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-20 9:04 a.m., Vlad Buslov wrote:
> 

> Hi Jamal,
> 
> Yes, I think the patch would work. However, we don't really need the
> flags check, if we are going to implement the new ops->delete_empty()
> callback because it can work like this:
> 
> if (!tp->ops->delete_empty) {
>     tp->deleting = true;
>     return tp->deleting;
> } else {
>    return tp->ops->delete_empty(tp);
> }
> 
> WDYT?

Looks reasonable - we kill two birds with one stone.
We'd need to revert the patch David took in.

cheers,
jamal
