Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF20F429957
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 00:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbhJKWL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 18:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235455AbhJKWL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 18:11:59 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737DEC061570
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 15:09:58 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id h196so8726759iof.2
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 15:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ewhdJrewVq9UEL9ms3PbdhPQHnTnwYJKNVbu3hDDnIs=;
        b=IW0C+PtTLYAOsNNnPt1srFJ3vnwYp8cTzRFDW9PTdE6eywhNJQcbYesMh5ktmVfTdV
         4yVMv795uwYKZLgaGTvGWYeQYp1QiBqMLREhAZ4tRoDZqiqkDTjhBicTtyYrP1DmLsi5
         ByFeaz+GU8WtD6fpIOHGLYG0b7WeQN2R7A86CUJVF0g5Ua+WRf2INPoG7Dorf8fbBQgw
         Z7qPfas0rrOJkahgzWLVIq7KYdyAjlH/XBaAubUO8PkQcusrKMOTNcqIvz3LpuZBTeWI
         ZimtmOpIkQts7yJ/nSLZyROyf735KSOoUbpmc7VSYUTgizBitf9D4TchvtD29ILXSEKs
         733g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ewhdJrewVq9UEL9ms3PbdhPQHnTnwYJKNVbu3hDDnIs=;
        b=qkfJJrx+PakQUvmcFz2TlKCfWTDrXIJnLHKx9WIpAW7cVdLe7K8RPeSETb5xgw9LYP
         iM3qgFIp2on6DzBhJYAqpddrqaPjsh7sjmSze/rc9TFHj2rlVClUOtuKgqVkodgT4mAq
         pZAlGETXJG03QbWpVT5FsCoFHFLRFvgIsgHI/isPXit/QMTSGHsiucRw4yd+0QXOL/NI
         2I780vTvd4UHiNXvNBzIdlu2I/5BmqhYj8/JLAYH01s31ehzGMYK/dlYiFGhEJvAQngL
         +8Op5JzGXSXxGCDeUj2vignlAXjJUxI3ltUnisG+Ur7wIoDxYoXwHHpAHOXkNOQQpdMs
         mumw==
X-Gm-Message-State: AOAM5308fP9niykrbdJJ4ZJ/QzPMMbpTyAdglk6oY69km6+gg1WNZsdw
        vyAejY13SduypDKXI1NsydWYlg==
X-Google-Smtp-Source: ABdhPJxlfRyNFDKh8WUUfjOVdiWiy9UCbwOf95eYRbcSUppoG4u6/fi+RinFfsDmAl1Y9TI52Ln9uA==
X-Received: by 2002:a5d:8242:: with SMTP id n2mr21382606ioo.170.1633990197757;
        Mon, 11 Oct 2021 15:09:57 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id k4sm4640029ilc.10.2021.10.11.15.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 15:09:57 -0700 (PDT)
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: Potential bio_vec networking/igb size dependency?
Message-ID: <2757afa0-1b27-8480-0830-9638b2495a85@kernel.dk>
Date:   Mon, 11 Oct 2021 16:09:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Been working on a change today that changes struct bio_vec, and it works
fine on the storage side. But when I boot the box with the change, I
can't ssh in. If I attempt to use networking on the box (eg to update
packages), it looks like the data is corrupt. Basic things work - I can
dhcp and get an IP and so on, but ssh in yields:

ssh -v box
[...]
debug1: Local version string SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.3
debug1: Remote protocol version 2.0, remote software version OpenSSH_8.2p1 Ubuntu-4ubuntu0.3
debug1: match: OpenSSH_8.2p1 Ubuntu-4ubuntu0.3 pat OpenSSH* compat 0x04000000
debug1: Authenticating to box as 'axboe'
debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
debug1: kex: algorithm: curve25519-sha256
debug1: kex: host key algorithm: ecdsa-sha2-nistp256
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
Connection closed by 207.135.234.126 port 22

I've got a vm image that I boot on my laptop, and that seems to
work fine. Hence I'm thinking maybe it's an igb issue? But for the
life of me, I cannot figure out wtf it is. I've looked at the skb_frag_t
uses and nothing pops out at me.

Trivial to reproduce, just add the below patch.

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 0e9bdd42dafb..e61967fb4643 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -33,6 +33,7 @@ struct bio_vec {
 	struct page	*bv_page;
 	unsigned int	bv_len;
 	unsigned int	bv_offset;
+	unsigned long	foo;
 };
 
 struct bvec_iter {

-- 
Jens Axboe

