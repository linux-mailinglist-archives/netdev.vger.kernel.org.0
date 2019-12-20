Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A74127B04
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 13:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfLTMZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 07:25:23 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40375 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbfLTMZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 07:25:23 -0500
Received: by mail-io1-f66.google.com with SMTP id x1so9180431iop.7
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 04:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=DDw8vDqetjvxWBgBhd1JVVLAZPZRDcaYFptyWz0MI4E=;
        b=viksnoxPevMGMvwrM3UC2p9j9oGCYgrOEWoBD9IdjulmzIy8erLSq80wKkokDS812r
         /Y5Wr5nIyyyCYqwpQAQYLGTm21WaI/Ajm5Sz9tDvuzB550UiJH22X/Ym/KzVFAmzPqMW
         uOb3DTx10kxTU8PbxIlGMG9uh21D7QycUrvJiVlnhDxxPYz8VXTNKbp3zMQiG61UqEhh
         uLBa0Ok9xL7Lm9JQPzOZsNT1CLtz+zQTMn+MTioBPeGJZOHJbQyeDe7TmvGFUlQ6/Hjd
         e2XP4qvMVugcxllsaaD3vo1nh0Pp3gM1S8ytK5zMANo2EO6eKw7MWbyqd1eA1xSiDntz
         EcRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=DDw8vDqetjvxWBgBhd1JVVLAZPZRDcaYFptyWz0MI4E=;
        b=DTmjodj0GEBIM1XQbNcdxq8gn1wDpcZLlsNPQpOm9O+Z0+Uhli4ZD5vQ5GcIQTubJ/
         hfG+CM9KnmD/DejJpDPE0/Tmj3PIfqM4wbHy5o6wMdfNYIijcRPW167seHBgfO1mtcy8
         6sb6cruzFCauqbOpRdJFNIpM3SmIw8SjA9kI/PsTu5sSh7NtugWERruTGKFjw3/FUVrE
         SVaEgj8fBMJIb+ZunwRYCrjbjtXvxWmxND5dPXo5/ZQCTuRcJ4AbKi2MdHk+JuhHbmoF
         XoDAxFTP8AJmek+Q81ugU/tfJ2KKJlEtC5aYflwJtlzsx+54pXceedXFMPEDl6CxJxLb
         EFTw==
X-Gm-Message-State: APjAAAVu4oCk5MdpXmCFAhob6s2FYvm/XGufrqQzrAcLPJ+ujMj9HrO4
        tZnr6SyzjHlGpf+T0LsJufLDfg==
X-Google-Smtp-Source: APXvYqz3sxUwuhVCUqBYtD/IYrUe1siruBn2MsrJiCb+Q0k3WnkbbwMTHza/gnQWd6T0wXcdElPjwA==
X-Received: by 2002:a6b:148c:: with SMTP id 134mr3974461iou.178.1576844722593;
        Fri, 20 Dec 2019 04:25:22 -0800 (PST)
Received: from [192.168.0.125] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id g6sm4534850ilj.64.2019.12.20.04.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 04:25:21 -0800 (PST)
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
Message-ID: <548e3ae8-6db8-a45c-2d9c-0e4a09dc737b@mojatatu.com>
Date:   Fri, 20 Dec 2019 07:25:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b9b2261a-5a35-fdf7-79b5-9d644e3ed097@mojatatu.com>
Content-Type: multipart/mixed;
 boundary="------------04C2C8ECD2429077D3D7A160"
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------04C2C8ECD2429077D3D7A160
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2019-12-20 7:11 a.m., Jamal Hadi Salim wrote:

> I see both as complementing each other. delete_empty()
> could serves like guidance almost for someone who wants to implement
> parallelization (and stops abuse of walk()) and
> TCF_PROTO_OPS_DOIT_UNLOCKED is more of a shortcut. IOW, you
> could at the top of tcf_proto_check_delete() return true
> if TCF_PROTO_OPS_DOIT_UNLOCKED is set while still invoking


Something like attached...

cheers,
jamal

--------------04C2C8ECD2429077D3D7A160
Content-Type: text/plain; charset=UTF-8;
 name="patchlet-doitunlocked"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="patchlet-doitunlocked"

ZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9jbHNfYXBpLmMgYi9uZXQvc2NoZWQvY2xzX2FwaS5j
CmluZGV4IDZhMGVhY2FmZGIxOS4uOGYxZTQ5YmE2NWZhIDEwMDY0NAotLS0gYS9uZXQvc2No
ZWQvY2xzX2FwaS5jCisrKyBiL25ldC9zY2hlZC9jbHNfYXBpLmMKQEAgLTMzMSw2ICszMzEs
MTEgQEAgc3RhdGljIGJvb2wgdGNmX3Byb3RvX2lzX2VtcHR5KHN0cnVjdCB0Y2ZfcHJvdG8g
KnRwLCBib29sIHJ0bmxfaGVsZCkKIAogc3RhdGljIGJvb2wgdGNmX3Byb3RvX2NoZWNrX2Rl
bGV0ZShzdHJ1Y3QgdGNmX3Byb3RvICp0cCwgYm9vbCBydG5sX2hlbGQpCiB7CisJaWYgKCEo
dHAtPm9wcy0+ZmxhZ3MgJiBUQ0ZfUFJPVE9fT1BTX0RPSVRfVU5MT0NLRUQpKSB7CisJCXRw
LT5kZWxldGluZyA9IHRydWU7CisJCXJldHVybiB0cC0+ZGVsZXRpbmc7CisJfQorCiAJc3Bp
bl9sb2NrKCZ0cC0+bG9jayk7CiAJaWYgKHRjZl9wcm90b19pc19lbXB0eSh0cCwgcnRubF9o
ZWxkKSkKIAkJdHAtPmRlbGV0aW5nID0gdHJ1ZTsK
--------------04C2C8ECD2429077D3D7A160--
