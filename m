Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E59F35A817
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 22:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhDIUpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 16:45:41 -0400
Received: from linux.microsoft.com ([13.77.154.182]:50440 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234160AbhDIUpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 16:45:40 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9E30220B3A35;
        Fri,  9 Apr 2021 13:45:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9E30220B3A35
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618001126;
        bh=r62bA5UADAfV3PUb50DNBL+EdI9H0Y9m/LeRSQPN37o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gknHwD8bVjVoNNLYAdx1i7pDOqiN6MsuTqwRo87oEXI7XYd3wAgwPW6k/IIuByexR
         lsggOCYWhLn647Zy71681bwUD7s0Zl4UF2GDRM8cetZeGzndw+a+NeKZfhfyYTkXxs
         P8vibQmKXdDSpEX3iHVNuQ0Xnf4CxLXiSyQdcMFY=
Received: by mail-pj1-f41.google.com with SMTP id i4so3478263pjk.1;
        Fri, 09 Apr 2021 13:45:26 -0700 (PDT)
X-Gm-Message-State: AOAM531lnttjbADoNlkZAPQ8SOGwvZ55KCRcvaFrn4QH36zz7Y6foy2X
        JxNlX1NHIyixUQH3Jl8jupFwk7PP3Hrd9dGFZ20=
X-Google-Smtp-Source: ABdhPJzkmB5ORYLETXtC9kGJ4jTO5b5JIeNMXCsjJHAZk8CL0YDb+MtiL4lXw0I+hcGSuxPLQIZ35wauIxb/07yHS0U=
X-Received: by 2002:a17:90b:295:: with SMTP id az21mr15536853pjb.11.1618001126225;
 Fri, 09 Apr 2021 13:45:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210409180605.78599-1-mcroce@linux.microsoft.com>
 <20210409180605.78599-3-mcroce@linux.microsoft.com> <20210409115455.49e24450@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409115455.49e24450@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Fri, 9 Apr 2021 22:44:50 +0200
X-Gmail-Original-Message-ID: <CAFnufp0fGEBHnuerrMVLaGUgAP3NYpiEMyW3R-AwDeG=R0sgHQ@mail.gmail.com>
Message-ID: <CAFnufp0fGEBHnuerrMVLaGUgAP3NYpiEMyW3R-AwDeG=R0sgHQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: use skb_for_each_frag() helper where possible
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Julia Lawall <julia.lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 8:54 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  9 Apr 2021 20:06:04 +0200 Matteo Croce wrote:
> > From: Matteo Croce <mcroce@microsoft.com>
> >
> > use the new helper macro skb_for_each_frag() which allows to iterate
> > through all the SKB fragments.
> >
> > The patch was created with Coccinelle, this was the semantic patch:
>
> Bunch of set but not used warnings here. Please make sure the code
> builds cleanly allmodconfig, W=1 C=1 before posting.
>

Will do.

> What pops to mind (although quite nit picky) is the question if the
> assembly changes much between driver which used to cache nr_frags and
> now always going skb_shinfo(skb)->nr_frags? It's a relatively common
> pattern.

Since skb_shinfo() is a macro and skb_end_pointer() a static inline,
it should be the same, but I was curious to check so, this is a diff
between the following snippet before and afer the macro:

int frags = skb_shinfo(skb)->nr_frags;
int i;
for (i = 0; i < frags; i++)
    kfree(skb->frags[i]);

 1 file changed, 8 insertions(+), 7 deletions(-)

--- ins1.s 2021-04-09 22:35:59.384523865 +0200
+++ ins2.s 2021-04-09 22:36:08.132594737 +0200
@@ -1,26 +1,27 @@
 iter:
         movsx   rax, DWORD PTR [rdi+16]
         mov     rdx, QWORD PTR [rdi+8]
         mov     eax, DWORD PTR [rdx+rax]
         test    eax, eax
         jle     .L6
         push    rbp
-        sub     eax, 1
+        mov     rbp, rdi
         push    rbx
-        lea     rbp, [rdi+32+rax*8]
-        lea     rbx, [rdi+24]
+        xor     ebx, ebx
         sub     rsp, 8
 .L3:
-        mov     rdi, QWORD PTR [rbx]
-        add     rbx, 8
+        mov     rdi, QWORD PTR [rbp+24+rbx*8]
+        add     rbx, 1
         call    kfree
-        cmp     rbx, rbp
-        jne     .L3
+        movsx   rax, DWORD PTR [rbp+16]
+        mov     rdx, QWORD PTR [rbp+8]
+        cmp     DWORD PTR [rdx+rax], ebx
+        jg      .L3
         add     rsp, 8
         xor     eax, eax
         pop     rbx
         pop     rbp
         ret
 .L6:
         xor     eax, eax
         ret

-- 
per aspera ad upstream
