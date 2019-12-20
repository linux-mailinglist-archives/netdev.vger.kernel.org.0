Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77597127BAA
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 14:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfLTN3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 08:29:39 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:41057 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727346AbfLTN3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 08:29:39 -0500
Received: by mail-il1-f194.google.com with SMTP id f10so7936403ils.8
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 05:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n8w00di8oFu8XoSiEEMzHnQO80wmBZDjwevFEesNfmI=;
        b=Py8+9qErCoVVWmqqALhOGpzgeaYLFski7ZzlcLsuRhBhPdqd8lVnk8Vz7r6bokMIxN
         A42z4ywZLCbkDmcqWPTnne5SfaeEDQoU+dQ2FbFBShMEYbRfTVXOMd6oiG8rTzaHr39N
         HVmmgp9YsfTzCJnNH0pdV1bMr0OCg+Moq8k2gvhX9Q1rNHx+fLzvg86g6aey0CoYvtOU
         zBTkh+sppEusNy/YVPDSxl5x0BQH0SFCVI/F1bB62dzYbp9cMhzqQV1nrO9rQGYf4V1w
         rnmDiFg1XbIkx9ul4ybR/QwDSHbAfjoBtPOKO6xUUlStFVnPAiS+LNxC/whkFovl3+ot
         R7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n8w00di8oFu8XoSiEEMzHnQO80wmBZDjwevFEesNfmI=;
        b=mnMSaVQiBzdNI46F7xtwb6DWryjHXLwfkYVK/K3/m3QrpdbbxRK4r9Nfism1eWJEKv
         XR3bECA0n72AGuApCD4Gejn05CdpnKQVueqJCuvhRtJ2KYxInz9M9COVpi4HzOnBqhcf
         KrvtZ7c7MwcZ10kE48jB4xrySZZ+x/yPkSGWMhD60aDPg18ji8qQzsL61HcTrZh8Iq6l
         JOIEVGGWnF0MZHnLoFmVFGzact3XKyHf/54kcozy+Z8m8PWdlRIEVStXvb77ToHV8CE8
         E9/9oQ4dEDdR2ozxy5RUH7mwmhaPbaLVuMAckKgQtNqFDUpDYBN5F8rF+78acGOgWWfT
         TXKg==
X-Gm-Message-State: APjAAAUtjhkG16vpG2MFgYvCYbdByOREI3DBfc5ZCQfPlxz8h+PcqCaf
        yCCWnR9tGv48ukPUI3WEoaWzFw==
X-Google-Smtp-Source: APXvYqzizxqtWsXiWwD3tjsLjJD7IKqeT/In9xsPRcLrwCwtz4UlsJfAhmZhaA5z2IiMa269dZZKFQ==
X-Received: by 2002:a92:d185:: with SMTP id z5mr12599585ilz.132.1576848578718;
        Fri, 20 Dec 2019 05:29:38 -0800 (PST)
Received: from [192.168.0.125] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id 81sm4574076ilx.40.2019.12.20.05.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 05:29:38 -0800 (PST)
Subject: Re: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
From:   Jamal Hadi Salim <jhs@mojatatu.com>
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
Message-ID: <cc0a3849-48c0-384d-6dd5-29a6763695f2@mojatatu.com>
Date:   Fri, 20 Dec 2019 08:29:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <548e3ae8-6db8-a45c-2d9c-0e4a09dc737b@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-20 7:25 a.m., Jamal Hadi Salim wrote:
> On 2019-12-20 7:11 a.m., Jamal Hadi Salim wrote:
> 
>> I see both as complementing each other. delete_empty()
>> could serves like guidance almost for someone who wants to implement
>> parallelization (and stops abuse of walk()) and
>> TCF_PROTO_OPS_DOIT_UNLOCKED is more of a shortcut. IOW, you
>> could at the top of tcf_proto_check_delete() return true
>> if TCF_PROTO_OPS_DOIT_UNLOCKED is set while still invoking
> 
> 
> Something like attached...

Vlad,
I tested this and it seems to fix the issue. But there may be
other consequences...

cheers,
jamal
