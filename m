Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B119FC3E36
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfJARLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:11:01 -0400
Received: from mx.cjr.nz ([51.158.111.142]:51096 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfJARLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 13:11:01 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id CD95F80A7A;
        Tue,  1 Oct 2019 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1569949858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=A8qzreD3Aoux2woi5Fj9Leo7MHUln5di2PJf76EqfBk=;
        b=dFbX3/Sttcc+w4N56hh9JsQQan/u+sklnnafSgX3HnMYorBA4/Tp4wJ4wYSIVCFrpQ+EWQ
        gABpNigKj86CLsd6ndZE0+fy9vsYgyBZK3Q13dBFzfvmuFB5VhaU1ZqeZJIce/5wWIM9qS
        qlq5vL+D7KBq5RTaKgMQvH60pq45hP8NTU97MqTbcuXhWWpktEfZEyjANTXrDJuBM20GLY
        QtaxMOigBL8naSmx17XTh96QHyyUBsWAj3kfTItGcr/10o+5GG3EAFssuwKsjwHXKqUSvD
        /x4fFmxkhtiJBbdEzQzh8fPj0AqkMz7P9FiS5fDUq9hSr4GU+B2dp4uVlSkEDw==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     netdev@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, davem@davemloft.net,
        smfrench@gmail.com
Cc:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH net-next 0/2] Experimental SMB rootfs support
Date:   Tue,  1 Oct 2019 14:10:26 -0300
Message-Id: <20191001171028.23356-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz;
        s=dkim; t=1569949858; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=A8qzreD3Aoux2woi5Fj9Leo7MHUln5di2PJf76EqfBk=;
        b=0jWn1vZPGuBwKQF7WiKqAsuPRIRJ3N6ed2Qygf2UT7EaH83ROI4bgdtmvNtdwFm5QIWd69
        6oIxrcsUUN9NTmYc7xXdVJD/42pwxWlXMKHtb+bZPCRMJ/Rh5lew+zNhQNijaW+OrVYlgC
        pYvdAfPGzkkLvKlvaZwuSR0It/e+cvTXxLIHPCpP02G8unGv7bFnk+LnAxYrl9nvRQpH6d
        k/9JFf7i9XiC/cnvwfHLcd+jj5F8PPm8gIPosMSb9zyJ/Pzl+hRfTkJi9WD7z8qUSpS1bH
        pyBAE0yCqVl9Rf4EEiQSVeBeEqM4NVWzAjQ5E1u1+KKmrSZUymN8oUG1a/qJEA==
ARC-Seal: i=1; s=dkim; d=cjr.nz; t=1569949858; a=rsa-sha256; cv=none;
        b=RvTtBqrBobfZxGGV9MX69/AOI8AfPqYC6jwIGMZOCdUSCiMFSIx5tqXan459VeTtwcCU0E
        ZhzfDPo7gg/CkHSuAQ/IYeNhrEtqqO4GHtwGRcRumnT/qdvF746rxTRiaHhR10RwCSKvZW
        T1E69VRt90LtHJ8PU5toi49jS54iQc9r5sfdDkXHChsLCkg4HcNcaaunbKha1NwwnbwuN+
        faPMN+xmPch+3YJGBkIThUH+qXD0ndoa57Qpkn/F/Hg+T8xEk96ofIaZSmgaQLqhW51A8Z
        UBahCDJ0M+xbdCT+Vwvh8BnzSUVVWvTYhASC7tsOa0Cw0Y15p+3KWXDFxIwIUQ==
ARC-Authentication-Results: i=1;
        mx.cjr.nz;
        auth=pass smtp.auth=pc smtp.mailfrom=pc@cjr.nz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series enables Linux to mount root file systems over the
network by utilizing SMB protocol.

Upstream commit 8eecd1c2e5bc ("cifs: Add support for root file
systems") introduced a new CONFIG_CIFS_ROOT option, a virtual device
(Root_CIFS) and a kernel cmdline parameter "cifsroot=" which tells the
kernel to actually mount the root filesystem over a SMB share.

The feature relies on ipconfig to set up the network prior to mounting
the rootfs, so when it is set along with "cifsroot=" parameter:

    (1) cifs_root_setup() parses all necessary data out of "cifsroot="
    parameter for the init process know how to mount the SMB rootfs
    (e.g. SMB server address, mount options).

    (2) If DHCP failed for some reason in ipconfig, we keep retrying
    forever as we have nowhere to go for NFS or SMB root
    filesystems (see PATCH 2/2). Otherwise go to (3).

    (3) mount_cifs_root() is then called by mount_root() (ROOT_DEV ==
    Root_CIFS), retrieves early parsed data from (1), then attempt to
    mount SMB rootfs by CIFSROOT_RETRY_MAX times at most (see PATCH
    1/2).

    (4) If all attempts failed, fall back to floppy drive, otherwise
    continue the boot process with rootfs mounted over a SMB share.

My idea was to keep the same behavior of nfsroot - as it seems to work
for most users so far.

For more information on how this feature works, see
Documentation/filesystems/cifs/cifsroot.txt.

Paulo Alcantara (SUSE) (2):
  init: Support mounting root file systems over SMB
  ipconfig: Handle CONFIG_CIFS_ROOT option

 init/do_mounts.c    | 49 +++++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/ipconfig.c | 10 +++++++--
 2 files changed, 57 insertions(+), 2 deletions(-)

-- 
2.23.0

