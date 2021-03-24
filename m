Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297C034833A
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbhCXUx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:53:59 -0400
Received: from namei.org ([65.99.196.166]:51310 "EHLO mail.namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230336AbhCXUx3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 16:53:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.namei.org (Postfix) with ESMTPS id 507624E1;
        Wed, 24 Mar 2021 20:50:33 +0000 (UTC)
Date:   Thu, 25 Mar 2021 07:50:33 +1100 (AEDT)
From:   James Morris <jmorris@namei.org>
To:     Arnd Bergmann <arnd@kernel.org>
cc:     linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>,
        Serge Hallyn <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>,
        x86@kernel.org, Ning Sun <ning.sun@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>,
        Imre Deak <imre.deak@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, cgroups@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Tycho Andersen <tycho@tycho.pizza>
Subject: Re: [PATCH 03/11] security: commoncap: fix -Wstringop-overread
 warning
In-Reply-To: <20210322160253.4032422-4-arnd@kernel.org>
Message-ID: <b8ebab59-1cec-42d-6fb9-44aa1a464ae2@namei.org>
References: <20210322160253.4032422-1-arnd@kernel.org> <20210322160253.4032422-4-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1665246916-699807841-1616619033=:3443171"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-699807841-1616619033=:3443171
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 22 Mar 2021, Arnd Bergmann wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc-11 introdces a harmless warning for cap_inode_getsecurity:
> 
> security/commoncap.c: In function ‘cap_inode_getsecurity’:
> security/commoncap.c:440:33: error: ‘memcpy’ reading 16 bytes from a region of size 0 [-Werror=stringop-overread]
>   440 |                                 memcpy(&nscap->data, &cap->data, sizeof(__le32) * 2 * VFS_CAP_U32);
>       |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The problem here is that tmpbuf is initialized to NULL, so gcc assumes
> it is not accessible unless it gets set by vfs_getxattr_alloc().  This is
> a legitimate warning as far as I can tell, but the code is correct since
> it correctly handles the error when that function fails.
> 
> Add a separate NULL check to tell gcc about it as well.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git fixes-v5.12

-- 
James Morris
<jmorris@namei.org>

--1665246916-699807841-1616619033=:3443171--
