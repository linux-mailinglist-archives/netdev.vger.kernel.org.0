Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F319F6E6FC6
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 01:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjDRXCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 19:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjDRXCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 19:02:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2568A55
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:02:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7C598219D7;
        Tue, 18 Apr 2023 23:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681858940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc;
        bh=fStdmM4/ad6XSlAtYkS0d1nhZInMh8+8sj+c2dWXU6Q=;
        b=jIA/lLfiP1sKbFdlSTOLJawcl5r3lUBP5oZ3RiJV/DdG1SZnvEE2HR1Q9URq3aXtpMND1b
        Wo5krj/aq6BEpkfz9TkCqtEObXnafqbs0Ny1BvYAsceH/Og37KzZMF4fjaav+GthGH1CsA
        QAYBhzXfi6mM4qSubBqA//bexXJeZGM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681858940;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc;
        bh=fStdmM4/ad6XSlAtYkS0d1nhZInMh8+8sj+c2dWXU6Q=;
        b=l9j1UM/ssEt9zn5nWF2X7w1e6CTgf7CRI27/XLZHx0IzytFBCq2if78iGApWPpk7q0WDJv
        hWdbfyL/ADheQeAw==
Received: from lion.mk-sys.cz (mkubecek.udp.ovpn2.prg.suse.de [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6A7BD2C141;
        Tue, 18 Apr 2023 23:02:20 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C399660517; Wed, 19 Apr 2023 01:02:16 +0200 (CEST)
Message-Id: <cover.1681858286.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 0/3] close uapi header copies w.r.t. include
To:     netdev@vger.kernel.org
Cc:     Thomas Devoogdt <thomas@devoogdt.com>
Date:   Wed, 19 Apr 2023 01:02:16 +0200 (CEST)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On multiple occasion, build on older systems with system <linux/...>
headers missing definitions or later changes failed which we either worked
around by adding conditional defines or fixed by adding a sanitized copy of
such header to uapi/ directory.

To prevent these problems, add sanitized copies of all uapi headers that we
include from any source file or from an already present uapi header copy
(and repeat the process recursively). For this purpose, add the update
scripts to the repository, update it to add missing files automatically and
run the update.

Michal Kubecek (3):
  scripts: add ethtool-import-uapi
  scripts: add all included uapi files on update
  update UAPI header copies

 scripts/ethtool-import-uapi |  67 +++++++++
 uapi/linux/const.h          |  36 +++++
 uapi/linux/if_addr.h        |  77 +++++++++++
 uapi/linux/if_ether.h       | 181 ++++++++++++++++++++++++
 uapi/linux/libc-compat.h    | 267 ++++++++++++++++++++++++++++++++++++
 uapi/linux/neighbour.h      | 224 ++++++++++++++++++++++++++++++
 uapi/linux/posix_types.h    |  38 +++++
 uapi/linux/rtnetlink.h      |   1 +
 uapi/linux/socket.h         |  38 +++++
 uapi/linux/stddef.h         |  47 +++++++
 uapi/linux/types.h          |  53 +++++++
 11 files changed, 1029 insertions(+)
 create mode 100755 scripts/ethtool-import-uapi
 create mode 100644 uapi/linux/const.h
 create mode 100644 uapi/linux/if_addr.h
 create mode 100644 uapi/linux/if_ether.h
 create mode 100644 uapi/linux/libc-compat.h
 create mode 100644 uapi/linux/neighbour.h
 create mode 100644 uapi/linux/posix_types.h
 create mode 100644 uapi/linux/socket.h
 create mode 100644 uapi/linux/stddef.h
 create mode 100644 uapi/linux/types.h

-- 
2.40.0

