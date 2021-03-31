Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4886234F871
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 08:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhCaGB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 02:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbhCaGBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 02:01:13 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B879EC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 23:01:12 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id w8so19987891ybt.3
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 23:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zWzcUFiS2AoGP7vZLs9mNuZHzVY0DCy6XuNA7FYLFa4=;
        b=pu30DvKmrkM9TYnlbTFSXU9xrHGuIlAHt6ID7mqdPnx1pBFKTPKaj+aDIa6/OvxCBF
         4fCDRbbabF/9LN+Z8T93zPtHOM0bxDX8ivcpC5nPmL+IEJHCZq6NA77hafB94WWZBIgT
         QXhyh2nli138y9tawTKO4fezCUV7gSND8OHJLud7goz7BV8y1+Ii2vfi7QzXvjP+81aH
         KHEzvjzOusjEmFLhJYLNhY21jW7qV+xrlRnnI04BAtQZFBl30KI803z81g498v5+A428
         6clenTRwD2ll0XPlGA+WtNFWexU88xlJ6SGcqhGnx38pN20lHna9NLvjoVQPJ/9DK5xq
         Xo6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zWzcUFiS2AoGP7vZLs9mNuZHzVY0DCy6XuNA7FYLFa4=;
        b=fMbMgjDqIob3ZNUeh8C8XkOCsugj8FszCrMiFsxNOrm0hb2L+sxeGZras+CL4EAXYb
         7m1HIRnbdPHoJFgVykyU2s1r4aM5aOoxEdKnRZl7vftVP92RSM0htoZOMi1rYEM+SLAq
         rW7kVN6+owToUZIiFONYPCpOITF8VnPoCe1nhC7vSD/DFy+Zun2caNv7DSBrg8T8Kr0L
         hZ9LmJv6bU4D3M+CaCGPAQ9iMZ0t1zP0g8xRZMbBK3DY37VTDqXRrx2mWpuZ/ViFaQ9i
         czcwJzuBdKyaDMBL+tz2u4Ec8B0fLz4kPpPYDksSOlN/zQB+S1GSGE/X6lx/2wMZQ13I
         QzEQ==
X-Gm-Message-State: AOAM530CGro6bvcW/C1BixsRyGrCLpMvnnA7NlB3UpwWn6fKW6DSZ13G
        oCTA9rG3R8KP+YclH2VPpZDVbiKNbXscBkwC8DwpmXQDn2s=
X-Google-Smtp-Source: ABdhPJxe+nUkE/VJpxweyhaMC/1QzXqk9DY9hP0vKcOn68eH+g8B+7i65Av+tRjkbk+5RQtXKNXSRGcG3ehXZpnyqPc=
X-Received: by 2002:a25:850b:: with SMTP id w11mr2467112ybk.518.1617170471719;
 Tue, 30 Mar 2021 23:01:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210330064551.545964-1-eric.dumazet@gmail.com> <CANn89i+YuMR6DuNk8YFZvHavxRCSNRp8MpC=rWz75N0CtN82DQ@mail.gmail.com>
In-Reply-To: <CANn89i+YuMR6DuNk8YFZvHavxRCSNRp8MpC=rWz75N0CtN82DQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 31 Mar 2021 08:01:00 +0200
Message-ID: <CANn89i+AW24XxLYMzA4Jb=QXCRb_RnWc_dTfFG19j3EP_mw9xQ@mail.gmail.com>
Subject: Re: [PATCH net-next] ip6_tunnel: sit: proper dev_{hold|put} in
 ndo_[un]init methods
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: multipart/mixed; boundary="0000000000008297a805beced7f6"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008297a805beced7f6
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 31, 2021 at 8:00 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Mar 30, 2021 at 8:45 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Same reasons than for the previous commits :
> > 6289a98f0817 ("sit: proper dev_{hold|put} in ndo_[un]init methods")
> > 40cb881b5aaa ("ip6_vti: proper dev_{hold|put} in ndo_[un]init methods")
> > 7f700334be9a ("ip6_gre: proper dev_{hold|put} in ndo_[un]init methods")
> >
> > After adopting CONFIG_PCPU_DEV_REFCNT=n option, syzbot was able to trigger
> > a warning [1]
> >
> > Issue here is that:
> >
> > - all dev_put() should be paired with a corresponding prior dev_hold().
> >
> > - A driver doing a dev_put() in its ndo_uninit() MUST also
> >   do a dev_hold() in its ndo_init(), only when ndo_init()
> >   is returning 0.
> >
> > Otherwise, register_netdevice() would call ndo_uninit()
> > in its error path and release a refcount too soon.
> >
> >
>
> Note to David & Jakub
>
> Can you merge this patch so that I can send my global fix for fallback
> tunnels, with a correct Fixes: tag for this patch ?
>
> Thanks !

Forgot to attach what the global fix would look like :

--0000000000008297a805beced7f6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-ipv6-remove-extra-dev_hold-for-fallback-tunnels.patch"
Content-Disposition: attachment; 
	filename="0001-ipv6-remove-extra-dev_hold-for-fallback-tunnels.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kmx1j7vy0>
X-Attachment-Id: f_kmx1j7vy0

RnJvbSAyYzljY2UwNjdhOWExYWVjMzJiMzIzZWY4MDE3OWIxODU2Yzc5NmFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+CkRh
dGU6IFR1ZSwgMzAgTWFyIDIwMjEgMTM6Mjk6MDggLTA3MDAKU3ViamVjdDogW1BBVENIIG5ldC1u
ZXh0XSBpcHY2OiByZW1vdmUgZXh0cmEgZGV2X2hvbGQoKSBmb3IgZmFsbGJhY2sgdHVubmVscwoK
TXkgcHJldmlvdXMgY29tbWl0cyBhZGRlZCBhIGRldl9ob2xkKCkgaW4gdHVubmVscyBuZG9faW5p
dCgpLApidXQgZm9yZ290IHRvIHJlbW92ZSBpdCBmcm9tIHNwZWNpYWwgZnVuY3Rpb25zIHNldHRp
bmcgdXAgZmFsbGJhY2sgdHVubmVscy4KCkZhbGxiYWNrIHR1bm5lbHMgZG8gY2FsbCB0aGVpciBy
ZXNwZWN0aXZlIG5kb19pbml0KCkKClRoaXMgbGVhZHMgdG8gdmFyaW91cyByZXBvcnRzIGxpa2Ug
OgoKdW5yZWdpc3Rlcl9uZXRkZXZpY2U6IHdhaXRpbmcgZm9yIGlwNmdyZTAgdG8gYmVjb21lIGZy
ZWUuIFVzYWdlIGNvdW50ID0gMgoKRml4ZXM6IGYyMWViMDE5NTY2MiAoImlwNl90dW5uZWw6IHNp
dDogcHJvcGVyIGRldl97aG9sZHxwdXR9IGluIG5kb19bdW5daW5pdCBtZXRob2RzIikKRml4ZXM6
IDYyODlhOThmMDgxNyAoInNpdDogcHJvcGVyIGRldl97aG9sZHxwdXR9IGluIG5kb19bdW5daW5p
dCBtZXRob2RzIikKRml4ZXM6IDQwY2I4ODFiNWFhYSAoImlwNl92dGk6IHByb3BlciBkZXZfe2hv
bGR8cHV0fSBpbiBuZG9fW3VuXWluaXQgbWV0aG9kcyIpCkZpeGVzOiA3ZjcwMDMzNGJlOWEgKCJp
cDZfZ3JlOiBwcm9wZXIgZGV2X3tob2xkfHB1dH0gaW4gbmRvX1t1bl1pbml0IG1ldGhvZHMiKQpT
aWduZWQtb2ZmLWJ5OiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+ClJlcG9ydGVk
LWJ5OiBzeXpib3QgPHN5emthbGxlckBnb29nbGVncm91cHMuY29tPgotLS0KIG5ldC9pcHY2L2lw
Nl9ncmUuYyAgICB8IDMgLS0tCiBuZXQvaXB2Ni9pcDZfdHVubmVsLmMgfCAxIC0KIG5ldC9pcHY2
L2lwNl92dGkuYyAgICB8IDEgLQogbmV0L2lwdjYvc2l0LmMgICAgICAgIHwgMSAtCiA0IGZpbGVz
IGNoYW5nZWQsIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvaXA2X2dyZS5j
IGIvbmV0L2lwdjYvaXA2X2dyZS5jCmluZGV4IDk2ODliZjlmNDZmMzQ3NTYyMzMwYTRkODYzMGMw
YjBiMTNhNDExZmMuLmJjMjI0ZjkxN2JiZDUzYmViOWI4YWY1YmRlZjNmYjk3OTRiOGVlNDQgMTAw
NjQ0Ci0tLSBhL25ldC9pcHY2L2lwNl9ncmUuYworKysgYi9uZXQvaXB2Ni9pcDZfZ3JlLmMKQEAg
LTM4Nyw3ICszODcsNiBAQCBzdGF0aWMgc3RydWN0IGlwNl90bmwgKmlwNmdyZV90dW5uZWxfbG9j
YXRlKHN0cnVjdCBuZXQgKm5ldCwKIAlpZiAoIShudC0+cGFybXMub19mbGFncyAmIFRVTk5FTF9T
RVEpKQogCQlkZXYtPmZlYXR1cmVzIHw9IE5FVElGX0ZfTExUWDsKIAotCWRldl9ob2xkKGRldik7
CiAJaXA2Z3JlX3R1bm5lbF9saW5rKGlnbiwgbnQpOwogCXJldHVybiBudDsKIApAQCAtMTUzOSw4
ICsxNTM4LDYgQEAgc3RhdGljIHZvaWQgaXA2Z3JlX2ZiX3R1bm5lbF9pbml0KHN0cnVjdCBuZXRf
ZGV2aWNlICpkZXYpCiAJc3RyY3B5KHR1bm5lbC0+cGFybXMubmFtZSwgZGV2LT5uYW1lKTsKIAog
CXR1bm5lbC0+aGxlbgkJPSBzaXplb2Yoc3RydWN0IGlwdjZoZHIpICsgNDsKLQotCWRldl9ob2xk
KGRldik7CiB9CiAKIHN0YXRpYyBzdHJ1Y3QgaW5ldDZfcHJvdG9jb2wgaXA2Z3JlX3Byb3RvY29s
IF9fcmVhZF9tb3N0bHkgPSB7CmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9pcDZfdHVubmVsLmMgYi9u
ZXQvaXB2Ni9pcDZfdHVubmVsLmMKaW5kZXggNjdlZTlkNThlYzVlZmNjODFlOGIyNzQwNmJkNGY1
N2EwY2FlYTcwYi4uMDdhMGEwNmE5YjUyYmM5OTc0ZTJmMzZiMTQ3N2MzNDFjOTUyZjk0YSAxMDA2
NDQKLS0tIGEvbmV0L2lwdjYvaXA2X3R1bm5lbC5jCisrKyBiL25ldC9pcHY2L2lwNl90dW5uZWwu
YwpAQCAtMTkyNSw3ICsxOTI1LDYgQEAgc3RhdGljIGludCBfX25ldF9pbml0IGlwNl9mYl90bmxf
ZGV2X2luaXQoc3RydWN0IG5ldF9kZXZpY2UgKmRldikKIAlzdHJ1Y3QgaXA2X3RubF9uZXQgKmlw
Nm4gPSBuZXRfZ2VuZXJpYyhuZXQsIGlwNl90bmxfbmV0X2lkKTsKIAogCXQtPnBhcm1zLnByb3Rv
ID0gSVBQUk9UT19JUFY2OwotCWRldl9ob2xkKGRldik7CiAKIAlyY3VfYXNzaWduX3BvaW50ZXIo
aXA2bi0+dG5sc193Y1swXSwgdCk7CiAJcmV0dXJuIDA7CmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9p
cDZfdnRpLmMgYi9uZXQvaXB2Ni9pcDZfdnRpLmMKaW5kZXggYTAxOGFmZGIzZTA2MmM5ZTY2NGQ0
Y2E0MjQxNzZhODU5ZjBhMzMyYy4uODU2ZTQ2YWQwODk1YjQ3YjU4ODk2ODUyYWZlZTNkNGEzOThi
MTM5ZSAxMDA2NDQKLS0tIGEvbmV0L2lwdjYvaXA2X3Z0aS5jCisrKyBiL25ldC9pcHY2L2lwNl92
dGkuYwpAQCAtOTYzLDcgKzk2Myw2IEBAIHN0YXRpYyBpbnQgX19uZXRfaW5pdCB2dGk2X2ZiX3Ru
bF9kZXZfaW5pdChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQogCXN0cnVjdCB2dGk2X25ldCAqaXA2
biA9IG5ldF9nZW5lcmljKG5ldCwgdnRpNl9uZXRfaWQpOwogCiAJdC0+cGFybXMucHJvdG8gPSBJ
UFBST1RPX0lQVjY7Ci0JZGV2X2hvbGQoZGV2KTsKIAogCXJjdV9hc3NpZ25fcG9pbnRlcihpcDZu
LT50bmxzX3djWzBdLCB0KTsKIAlyZXR1cm4gMDsKZGlmZiAtLWdpdCBhL25ldC9pcHY2L3NpdC5j
IGIvbmV0L2lwdjYvc2l0LmMKaW5kZXggNDg4ZDMxODFhZWMzYTU1NThkYmVmYjYxNDU0MDA2Mjc1
MzVkZjc2MS4uZmYyY2EyZTdjN2Y1MDQ1NjYzMDY5ZWE1NzI1NjBkNThhYmVlMjk3MCAxMDA2NDQK
LS0tIGEvbmV0L2lwdjYvc2l0LmMKKysrIGIvbmV0L2lwdjYvc2l0LmMKQEAgLTE0NzAsNyArMTQ3
MCw2IEBAIHN0YXRpYyB2b2lkIF9fbmV0X2luaXQgaXBpcDZfZmJfdHVubmVsX2luaXQoc3RydWN0
IG5ldF9kZXZpY2UgKmRldikKIAlpcGgtPmlobAkJPSA1OwogCWlwaC0+dHRsCQk9IDY0OwogCi0J
ZGV2X2hvbGQoZGV2KTsKIAlyY3VfYXNzaWduX3BvaW50ZXIoc2l0bi0+dHVubmVsc193Y1swXSwg
dHVubmVsKTsKIH0KIAotLSAKMi4zMS4wLjI5MS5nNTc2YmE5ZGNkYWYtZ29vZwoK
--0000000000008297a805beced7f6--
