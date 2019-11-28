Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACAF410C29E
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 03:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfK1Cyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 21:54:36 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:42220 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbfK1Cyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 21:54:35 -0500
Received: by mail-pj1-f68.google.com with SMTP id y21so11174341pjn.9;
        Wed, 27 Nov 2019 18:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QVjDMSx5+CBlZfoasvUKpNpCEQRNUdLJKpLr0vW0iOg=;
        b=BRH3uQm1T+yc8VQ4P+eIBX1WdUJFLuB3ohcUxgwuFqzGYKDReyi0lshQsuePqD7ZGM
         09Wi7AhPzU9ZO8hfI62na4Plu6dO7+9B86PzDj1+3dCjEzZ3lo4uAgNTqKqMbaQ9Isvg
         TfWZwv5zQtAbHjms3qTgkj6w/4pHIKen9v3+rxQJc9/NBzBK/gZ043UEk60sF9IDbhhH
         Ih4CSwgX1m7oRIEjFE7c2aBQX3XgsWwvB/W7YLK0NQSBPH6wVvhy+zWKPW3P7lli1hDJ
         QrUI0X/BPqN/JkMp+gDl34rPQsz/NEkPCoAQFyPJ3cvJmL/ILTz1WjW9qva6cRJh8mHq
         bO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QVjDMSx5+CBlZfoasvUKpNpCEQRNUdLJKpLr0vW0iOg=;
        b=kX1MVTxQ15SaoZnIo3lAbZNE1SEMU6xFh28GcDP+pS903cbUYaItinKzcJphcU0Kvy
         ObdqacJXWNpRDuJX/qgAjsBTMG1LvcvGc8DQaFgBrFy+hagrUFNd14NHQim/9JePBrQX
         F8GasSppRlh4mGC4VMeBj5RB6M8tCOEXEmG3ck30cmBnJ6XL7VgQ6M2NA0zzVzIVdLl4
         2KmVzVY/Sonhj50vNJQ1n+X6F7cGaCVhmdkpaRtin+iMHS0zfOF0GqYhId3tPzi+LEF4
         fe5cJH52pCHXrOIx5nnT3bM46jnSnZIFjQ9RRZ045WeWMW6sXYHXP0EE9lqqc2S+umRv
         n7Tw==
X-Gm-Message-State: APjAAAUBmSyUpdO563BXMFsR1YmjOEW9B1CxqUzdR/dO/kwxbdHJ+ATA
        gk/xeD3WluuxFoQoOyjpqiUGsUGv
X-Google-Smtp-Source: APXvYqwM+rGj3t9fvCM8AlSg+hRLmzqTozOSfjXYhfAemzMrUo7KZkLxbiymcoSxUbgSSjErtrU+mw==
X-Received: by 2002:a17:902:be16:: with SMTP id r22mr7508188pls.2.1574909674528;
        Wed, 27 Nov 2019 18:54:34 -0800 (PST)
Received: from [172.20.20.156] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id j23sm17761332pfe.95.2019.11.27.18.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 18:54:34 -0800 (PST)
Subject: Re: [RFC net-next 15/18] virtio_net: implement XDP prog offload
 functionality
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
 <20191126100744.5083-16-prashantbhole.linux@gmail.com>
 <20191127153253-mutt-send-email-mst@kernel.org>
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <73323055-3f8a-802d-87da-e8f61ef5cfb7@gmail.com>
Date:   Thu, 28 Nov 2019 11:53:41 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191127153253-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/28/19 5:42 AM, Michael S. Tsirkin wrote:
> On Tue, Nov 26, 2019 at 07:07:41PM +0900, Prashant Bhole wrote:
>> From: Jason Wang <jasowang@redhat.com>
>>
>> This patch implements bpf_prog_offload_ops callbacks and adds handling
>> for XDP_SETUP_PROG_HW. Handling of XDP_SETUP_PROG_HW involves setting
>> up struct virtio_net_ctrl_ebpf_prog and appending program instructions
>> to it. This control buffer is sent to Qemu with class
>> VIRTIO_NET_CTRL_EBPF and command VIRTIO_NET_BPF_CMD_SET_OFFLOAD.
>> The expected behavior from Qemu is that it should try to load the
>> program in host os and report the status.
> 
> That's not great e.g. for migration: different hosts might have
> a different idea about what's allowed.
> Device capabilities should be preferably exported through
> feature bits or config space such that it's easy to
> intercept and limit these as needed.

These things are mentioned in the TODO section of cover letter.
Having offload feature enabled should be a migration blocker.
A feature bit in virtio for offloading capability needs to be added.

> 
> Also, how are we going to handle e.g. endian-ness here?

For now I feel we should block offloading in case of cross endian
virtualization. Further to support cross endian-ness, the requests for 
offloading a map or program should include metadata such as BTF info.
Qemu needs to handle the conversion.

> 
>>
>> It also adds restriction to have either driver or offloaded program
>> at a time.
> 
> I'm not sure I understand what does the above say.
> virtnet_xdp_offload_check?
> Please add code comments so we remember what to do and when.
> 
>> This restriction can be removed later after proper testing.
> 
> What kind of testing is missing here?

This restriction mentioned above is about having multiple programs
attached to the same device. It can be possible to have a program
attached in driver mode and other in offload mode, but in current code
only one mode at a time is supported because I wasn't aware whether
bpf tooling supports the case. I will add a comment or remove the
restriction in the next revision.

> 
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> Co-developed-by: Prashant Bhole <prashantbhole.linux@gmail.com>
>> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> 
> Any UAPI changes need to be copied to virtio-dev@lists.oasis-open.org
> (subscriber only) list please.

Sure.

Thanks.
