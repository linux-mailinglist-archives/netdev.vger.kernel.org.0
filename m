Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DD4291030
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 08:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437151AbgJQGg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 02:36:27 -0400
Received: from mout.gmx.net ([212.227.15.18]:47577 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390021AbgJQGg0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 02:36:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1602916584;
        bh=OoC7kCSQUKM6hdGhhq1JeJdWrCwdFv7cAaibBHIA0X8=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=fnCroEcjZ4u/LuEP2Zvs/Bv1O9ERSTsKzRPH9spG7BLeG7kK81ktp+rgdns5YYEpa
         VE8evWJ4Gk8sVejS+ZYTcKJqtYK3DlDxY3Ds4/tejj2nXs20jwVmQ4Mw3JvlYYvROZ
         wcbxmOUeLHljrlDCWEELf/PptIMcyS3qb2d2HQcQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.simpson.net ([185.191.217.9]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MVvL5-1kvLXG261V-00RmP6; Sat, 17
 Oct 2020 04:26:07 +0200
Message-ID: <1805c3bd76ccfe66770636081910a40b63405eef.camel@gmx.de>
Subject: Re: [patchlet] r8169: fix napi_schedule_irqoff() called with irqs
 enabled warning
From:   Mike Galbraith <efault@gmx.de>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Date:   Sat, 17 Oct 2020 04:26:06 +0200
In-Reply-To: <e65ea1a0-fa97-5d07-fbbf-4071f91e2429@gmail.com>
References: <9c34e18280bde5c14f40b1ef89a5e6ea326dd5da.camel@gmx.de>
         <7e7e1b0e-aaf4-385c-b82c-79cac34c9175@gmail.com>
         <20201016142611.zpp63qppmazxl4k7@skbuf>
         <42ff951039f3c92def8490d3842e3f7eaf6900ff.camel@gmx.de>
         <e65ea1a0-fa97-5d07-fbbf-4071f91e2429@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:VbrbWPxppkL3T7qWlY60g1a3kFTBVn5A0oW6+dz8nyas/xIlG+b
 JLyNuzVsETc7yhoJH5aZUtupJw8U506jWKG1NTqNK//GBqF9CrAmHmkZAdFn5870QiEq8T4
 ZdcIgiICzWfkBz8yXqrRtcx6v/t6r7/Ye9cVmqr6+4Hx36+iBDAHLi5cUryfqIijvS5vI9v
 AupbJ28CsdbHWgS+q8Oyw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:OWIeUsxyTQU=:ICCvjcheHj+njgBsgDD4X5
 7BGSaiP5bLCv6hUfxXUYwwQe+i+5rt/YP3JQVcT3P/CscqlGNaoQ6OaDmI8kUzs0F6wOVHu7+
 h+y7Mii8Ys5+Xh+0YHEL9wgSCuIEQEICT7SywAbbCKIVm8tBo5p1H8eQusudeiKTfbYaTJujP
 d63f3pGEgooIJbMJ6s2peZ078+ZRKmW6cEGDWgDCUTIzO0aG6fsFVHG4PuzvRqkmrLKdGialx
 8ZUaZCrIPQ6PGtho4p+SN/6nXlU0TwULhcCP7pzMBlB+1naktYHP1tSiPy2UuKzoR2IgDSWBw
 xHkvQf+CzCT7SnMOAm4mmPDaNcPZAAzLt5+bj4cr5uQFVpi8AYf4eQrTyHrOmVPhum+wS6kV4
 aiaXxeYHrp2jqAObzvWB2G/F529YqyQA74GuUuoAmRHAsW2ZLsoHzm3gYI9L/J5xqnG30AMy1
 HR0BKCChV00t1O7Ev2sEQxR1SoNnrS3kpVvZ95Rc+4s1WDqgCilhwps87tcJnXeE03x2dXHdY
 B3EPyfsBKCqz/UmmU2wQ0auRc+FDLAFxYAxZMPa1T2q/TfDlXxFVIJwYPE0CXxFBsakUgpLnU
 FuJXXjo7tn9/xA9modlv73RP7p5XOEQz/N1HLsLkdVCV9LATltrQKgOq6luVCUjDx3TrNI4mW
 eMfiaz8lRSOa0zBV/jYCEfivmT/06+8ReZTk+qRkTft01fOMLOk1csTOyROxaqlF6671QMCYw
 oAyrQzn07qygXPPZeOC+uh/taRVMypE1a42QH1s6aWnNo0CNFmcUaqIzpf3uzyoD/yX6f+gte
 nAHIwYQOv50HJyXEuQzK6fl9LXwscT5X8f+L+9yP5a92OGXZL68DhwBzK4GksIa7WoEaM8ELR
 nBJvGCzI7uWW4oXj2y5Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-16 at 21:15 +0200, Heiner Kallweit wrote:
>
> But we should spend at least a few thoughts on whether and how the
> irqoff version could be improved. This would have two benefits:

I disagree, using the irqoff version in a place that irqoff is not
always true is a bug.

*Maybe* it would be worth it to twiddle the regular version, but color
me highly skeptical.  Branches ain't free (and arm for one already adds
one), and static branches are not generic whereas napi_schedule() is.

	-Mike

