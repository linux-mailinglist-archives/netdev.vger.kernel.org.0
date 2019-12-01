Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D2710E2A2
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 17:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfLAQj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 11:39:59 -0500
Received: from mail-io1-f47.google.com ([209.85.166.47]:34635 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfLAQj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 11:39:58 -0500
Received: by mail-io1-f47.google.com with SMTP id z193so37561099iof.1;
        Sun, 01 Dec 2019 08:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nrzdauqQjl+Gtu4h2eEhHK1/fwKIUPO8zlYq2SyP7VU=;
        b=ewfZ9rhFb16403kL4WxpLnimNbUG0wY3issAExVqK4oYlk5emArVaen+d8V4glbP4D
         j79zQFiQqDjdtH+m3HqXclV7wgEVsDJ3WmXz+B6Ui9wr3wHE4WCO5boTDLCQSV7luMmg
         PfHyUFtngtYsV3R7I/y2yjx7OZaqwCNQjI+yRaBvHxqJJ0BIvDT5CD+6Xn1Jq+RLBpCp
         J7rPkdgMo66/vwFp0uyU60wwut9eI8vpH/oJ5jGcRQtx8IpsjQ/q6fr1hv+OEVi41eU4
         PHtDcdrowVPLVCdOpyRvMaUJqNgSZKcSTZG1RQ4J8hskjKAgZO3T8LO4Rmnk0vd4DfCI
         cUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nrzdauqQjl+Gtu4h2eEhHK1/fwKIUPO8zlYq2SyP7VU=;
        b=k2ur6plUaoCIXy7scKuSCfQy+U5+qH6xFdS9be/uVl31fh2eQCBYmhBK30FbJWBe3H
         NfPGY5RQOOYWPtR0lnUN1tQiD6+qiYB6flBbgLy5tArPe/acD2iJRQYLEscXCmMxzGC7
         7g09P6m0LpgtvdBGja3MitX0hvAgsZ89+wVIvKyxM/KI3j104vTvuxM7Vkgr278V7l0F
         89FG8jDzub43FoPOBBvgAbt77LAzA6rupbx4l0tNJf7oDQ7tU0D4pPAVzo+tlmqCYKSz
         r1oa9uU2aW383r+o7bCMIiDX+6DsVhLL+zyRTiX1jDe+AGx1mBuzG8259ti0yXNetdPQ
         1t2A==
X-Gm-Message-State: APjAAAUS19Pzy5NcR8XrUk2sc/VLgFuNXNDReXrMj1WVxBaEa6jNw2tT
        gkhC8Njyj3O87T184OIlX59fCDCh
X-Google-Smtp-Source: APXvYqzkylSQoi2vRq1vJFxYRl9Rz/plJFEp27CXda6upU9mu10SEPZ9DxmxSQWBQOOEjpdZIFouWA==
X-Received: by 2002:a02:ac0a:: with SMTP id a10mr25083180jao.53.1575218396476;
        Sun, 01 Dec 2019 08:39:56 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:fd6b:fde:b20f:61ed])
        by smtp.googlemail.com with ESMTPSA id 3sm2406097iow.71.2019.12.01.08.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Dec 2019 08:39:55 -0800 (PST)
Subject: Re: [RFC net-next 08/18] tun: run offloaded XDP program in Tx path
To:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
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
 <20191126100744.5083-9-prashantbhole.linux@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f39536e4-1492-04e6-1293-302cc75e81bf@gmail.com>
Date:   Sun, 1 Dec 2019 09:39:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191126100744.5083-9-prashantbhole.linux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/19 4:07 AM, Prashant Bhole wrote:
> run offloaded XDP program as soon as packet is removed from the ptr
> ring. Since this is XDP in Tx path, the traditional handling of
> XDP actions XDP_TX/REDIRECT isn't valid. For this reason we call
> do_xdp_generic_core instead of do_xdp_generic. do_xdp_generic_core
> just runs the program and leaves the action handling to us.

What happens if an offloaded program returns XDP_REDIRECT?

Below you just drop the packet which is going to be a bad user
experience. A better user experience is to detect XDP return codes a
program uses, catch those that are not supported for this use case and
fail the install of the program.
