Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6725D6A3BC9
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 08:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjB0Hls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 02:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjB0Hlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 02:41:47 -0500
X-Greylist: delayed 36967 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 26 Feb 2023 23:41:46 PST
Received: from ocelot.miegl.cz (ocelot.miegl.cz [195.201.216.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3019C1ABE8;
        Sun, 26 Feb 2023 23:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=miegl.cz; s=dkim;
        t=1677483704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GgFp2nnTQfZeAkxi8d5Hl8jziSSGJptiu7paD/6J85Y=;
        b=E1qJnL0+IgOZfWm4kcY+yQwcnEa4feKj0F8Io1snbSUMarq7ZLY4wqQcEmSNjEpFbtYfvf
        T/vzSBrrR0pXuFklxaP9IEjAMr9dGsgrSHmAnxHGGghg4qAktBlVOGF192fnRiGYKs3jxl
        vslsgYd7Grb2vjnKvmBJdxLEoGwTZWtg70rowoqYCmvZ4wNWX6f+lR5gDW1rqN0SV+oxEh
        inlqbhrFd4Oc4HCx6gKGYOKjTxPAUd7dtlffVsM8v4zJQKv13rBT6FE+ELcfa1Ic2PYKMg
        h6E6RfdOioWC70EyjXLwll0KsJBI16Z/I8veku4uMo1vBY/TtzCS5rmtpVJhZg==
From:   Josef Miegl <josef@miegl.cz>
Cc:     Josef Miegl <josef@miegl.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] net: geneve: accept every ethertype
Date:   Mon, 27 Feb 2023 08:41:03 +0100
Message-Id: <20230227074104.42153-1-josef@miegl.cz>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        TO_EQ_FM_DIRECT_MX autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Geneve encapsulation, as defined in RFC 8926, has a Protocol Type
field, which states the Ethertype of the payload appearing after the
Geneve header.

Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed the
use of other Ethertypes than Ethernet. However, for a reason not known
to me, it imposed a restriction that prohibits receiving payloads other
than IPv4, IPv6 and Ethernet.

This patch removes this restriction, making it possible to receive any
Ethertype as a payload, if the IFLA_GENEVE_INNER_PROTO_INHERIT flag is
set.

This is especially useful if one wants to encapsulate MPLS, because with
this patch the control-plane traffic (IP, LLC) and the data-plane
traffic (MPLS) can be encapsulated without an Ethernet frame, making
lightweight overlay networks a possibility.

Changes in v2:
  - added a cover letter
  - lines no longer exceed 80 columns


Josef Miegl (1):
  net: geneve: accept every ethertype

 drivers/net/geneve.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

-- 
2.37.1

