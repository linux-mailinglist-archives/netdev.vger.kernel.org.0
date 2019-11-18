Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDECD1009E7
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 18:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfKRRIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 12:08:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20442 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726314AbfKRRIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 12:08:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574096903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VPhkdVuE4r8k1SoS9flKCm6UkmJ4VwiHYivf993T13I=;
        b=RKHIq5PPW96Q8iPFoJILNjUn7ci4TBGaqEroQCJGihW7RfDSVEvVajinlS0tqCTma6k+sp
        AprnwOQYpCZgTABcCswwe2yIShY4zuiP9rRg3GngLP3mhjJ8xRE0qRhlhl3/VX47pLFWE6
        1HRe1b8fzqwdVa7rCC/k2o+1fH+h820=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-MmOcKuRKMUm7pxyva_uVWQ-1; Mon, 18 Nov 2019 12:08:22 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC85D477;
        Mon, 18 Nov 2019 17:08:20 +0000 (UTC)
Received: from jtoppins.rdu.csb (ovpn-121-82.rdu2.redhat.com [10.10.121.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EC5F60307;
        Mon, 18 Nov 2019 17:08:18 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] bnx2x: initialize ethtool info->fw_version before use
Date:   Mon, 18 Nov 2019 12:07:53 -0500
Message-Id: <f40bcf8cd93677c12bca1f06e74385c9a5f49819.1574096873.git.jtoppins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: MmOcKuRKMUm7pxyva_uVWQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the info->fw_version has garbage in the buffer this can lead to a BUG()
being generated in strlcat() due to the use of strlen(). Initialize the
buffer before use.

The use of a systemtap script can demonstrate the problem by injecting
garbage into fw_version:

    [root@localhost ~]# cat net-info.stp
    //
    // compile and run with command
    //# stap -g   net-info.stp
    //
    probe begin { printf("net-info  version 01.01\n")}

    function memset(msg:long) %{
    =09memset((char*)STAP_ARG_msg,-1,196);
    %}

    probe module("bnx2x").function("bnx2x_get_drvinfo")
    {
      printf("In function\n");
      memset(register("rsi"));
    }

    [root@localhost ~]# stap -g net-info.stp &
    net-info  version 01.01
    [root@localhost ~]# ethtool -i eth1

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/=
net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index 4a0ba6801c9e..49b906396dcf 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -1111,6 +1111,8 @@ static void bnx2x_get_drvinfo(struct net_device *dev,
 =09int ext_dev_info_offset;
 =09u32 mbi;
=20
+=09info->fw_version[0] =3D 0;
+
 =09strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
 =09strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
=20
--=20
2.16.4

