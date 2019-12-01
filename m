Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B91910E2A6
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 17:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfLAQpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 11:45:49 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:45528 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfLAQpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 11:45:49 -0500
Received: by mail-il1-f195.google.com with SMTP id o18so31040594ils.12;
        Sun, 01 Dec 2019 08:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5PiLHcJSPrRzekdCH8FxUdbB33YPjM+w/haI6Mc/7K0=;
        b=H3B9CJAMvF39dG9jba2KaW6vAmuzrXQ3PXh+V4jw2su6sfjsnh7aze0miemyZwB0AJ
         gdfW6awNfgrnRExN4kIwJ7J+A8F2JieY8l3ccgURz5K+/K6Pl/brPyqmbbzhDZ7KUc51
         VVJ5XZCTS2Fq+F8bzv9mcOrFiao9K5ubJVXEDelrYhCWfu5VUp5rbQgAQIDBJ4Anc41D
         wxo1+s13Wa2V7sIN4oeWncBPLqhyMIoQnx1r8fqjvvqOwnkAEfBbovQZhVzLZarDe/Xp
         pkg4JuvdXs6zkvmLaV9kAq6wN6yAUsYaLrWj5EnGDXQsAnl8BQKKUBRbhkG+lMEGCqe5
         WAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5PiLHcJSPrRzekdCH8FxUdbB33YPjM+w/haI6Mc/7K0=;
        b=bY3uuAFOidmEjsi+w85XstkLxYGxgoRnlh/U//o+D7FCxGAbhj42OaZbOWDrbwfUt9
         Mb+J2iF+JsLDWTkBHMaFqpAfmQbUbAA+Yj2nB6IlX2SVNBJ8yYIAxkhDyi+A6ADcjS98
         p1eia+brdr48PzWiU2EGwbBCBKppP0HC8wim5FhDz8ya6cdtNSqKGuAbr57jp5NfhzvI
         hZLMqtA7swdIMQsnJ6Urapc5h2ILdqDyxIEG9mON8byWRTThG74yhWCqP0Nog3S/m+bF
         UdfvaaxMsg85cq2Zwey+WQza+SUs5WAPXs04cS/dTt/IRYdNowZqusKAjlc6WAkxXpWQ
         FQ/A==
X-Gm-Message-State: APjAAAXJSkEK1WOjvNCLHwFRd3CwA7YW+p/w4rsDfoOZhg9zAEiGSeJf
        VRbBlhsblZiYb3kOhuXMeJTCUFCN
X-Google-Smtp-Source: APXvYqzJ++V1IzVJ3BpcLuNfGspGbhWYTRszgvqw22CsV9Df5CjZ8uXk7CNjwTVdTrxJdHggwnzy+Q==
X-Received: by 2002:a92:3a88:: with SMTP id i8mr63854697ilf.254.1575218748467;
        Sun, 01 Dec 2019 08:45:48 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:fd6b:fde:b20f:61ed])
        by smtp.googlemail.com with ESMTPSA id s8sm5116156ilq.14.2019.12.01.08.45.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Dec 2019 08:45:47 -0800 (PST)
Subject: Re: [RFC net-next 07/18] tun: set offloaded xdp program
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
 <20191126100744.5083-8-prashantbhole.linux@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3ff23a11-c979-32ed-b55d-9213c2c64bc4@gmail.com>
Date:   Sun, 1 Dec 2019 09:45:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191126100744.5083-8-prashantbhole.linux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/19 4:07 AM, Prashant Bhole wrote:
> From: Jason Wang <jasowang@redhat.com>
> 
> This patch introduces an ioctl way to set an offloaded XDP program
> to tun driver. This ioctl will be used by qemu to offload XDP program
> from virtio_net in the guest.
> 

Seems like you need to set / reset the SOCK_XDP flag on tfile->sk since
this is an XDP program.

Also, why not add this program using netlink instead of ioctl? e.g., as
part of a generic XDP in the egress path like I am looking into for the
host side.
