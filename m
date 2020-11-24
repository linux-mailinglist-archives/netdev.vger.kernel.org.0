Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A6E2C3234
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 21:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgKXUwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 15:52:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbgKXUwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 15:52:37 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9859B2076E;
        Tue, 24 Nov 2020 20:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606251156;
        bh=shBh0jaiAA1DtqBnMB8Y0ENRSp86LJdgotAQcYDs2FA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XJBrXQw5E2kbbL4zm2msEnWIzN9YvSA2bdGLc6pG4If/RnRE94UQ+RhYwr2aRJIoy
         BNsWoCqd+6OsLrwwA/iuff4UxfnDfCsa4XOSRFl4KAwHP+ILLSVabBGdCl97wb9WdF
         8fCWM05z+gOsyBhrRBQrQ6Ms+agcYP/CVjg+RBGg=
Date:   Tue, 24 Nov 2020 12:52:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 3/4] net: socket: simplify dev_ifconf handling
Message-ID: <20201124125235.0ce22af8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124151828.169152-4-arnd@kernel.org>
References: <20201124151828.169152-1-arnd@kernel.org>
        <20201124151828.169152-4-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 16:18:27 +0100 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The dev_ifconf() calling conventions make compat handling
> more complicated than necessary, simplify this by moving
> the in_compat_syscall() check into the function.
> The implementation can be simplified further, based on the
> knowledge that the dynamic registration is only ever used
> for IPv4.

Looks like this one breaks bisection (/breaks build which patch 4 then
fixes):


In file included from ../arch/x86/include/asm/sigframe.h:8,
                 from ../arch/x86/kernel/asm-offsets.c:17:
../include/linux/compat.h:348:29: error: field =E2=80=98ifru_settings=E2=80=
=99 has incomplete type
  348 |   struct compat_if_settings ifru_settings;
      |                             ^~~~~~~~~~~~~
../include/linux/compat.h:352:8: error: redefinition of =E2=80=98struct com=
pat_ifconf=E2=80=99
  352 | struct compat_ifconf {
      |        ^~~~~~~~~~~~~
../include/linux/compat.h:108:8: note: originally defined here
  108 | struct compat_ifconf {
      |        ^~~~~~~~~~~~~
make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make[1]: *** [prepare0] Error 2
make: *** [__sub-make] Error 2
