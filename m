Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEBB6603F8
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbjAFQJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbjAFQIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:08:55 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E6B3225F;
        Fri,  6 Jan 2023 08:08:30 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 306G86fA1390822
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 6 Jan 2023 16:08:07 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 306G7waq2910560
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 6 Jan 2023 17:07:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673021281; bh=34wK8yK2QM8C7OYxwb3tmF/R6nqgC8vJ0iImqPFm0FI=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=GqF4nVpZWhtQ3zPyUtdVYUBIanRUgjr75i4L3DmoguXcxErGof/XzPW7cXRUyMkOP
         WaFoF+0Ujyl3ml7pITVQ+6Hyp52euTKC76tB644WZ/UrDUswJUxoFXns0MfuxDSkEo
         nYgX+8AJiuDz/H4whnrWnF6TIsYKaFsziScz+Qvc=
Received: (nullmailer pid 100758 invoked by uid 1000);
        Fri, 06 Jan 2023 16:07:58 -0000
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Hayes Wang <hayeswang@realtek.com>, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH 0/2] r8152: allow firmwares with NCM support
Date:   Fri,  6 Jan 2023 17:07:37 +0100
Message-Id: <20230106160739.100708-1-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some device and firmware combinations with NCM support will
end up using the cdc_ncm driver by default.  This is sub-
optimal for the same reasons we've previously accepted the
blacklist hack in cdc_ether.

The recent support for subclassing the generic USB device
driver allows us to create a very slim driver with the same
functionality.  This patch set uses that to implement a
device specific configuration default which is independent
of any USB interface drivers.  This means that it works
equally whether the device initially ends up in NCM or ECM
mode, without depending on any code in the respective class
drivers.

Bjørn Mork (2):
  r8152: add USB device driver for config selection
  cdc_ether: no need to blacklist any r8152 devices

 drivers/net/usb/cdc_ether.c | 114 ------------------------------------
 drivers/net/usb/r8152.c     | 113 +++++++++++++++++++++++++----------
 2 files changed, 81 insertions(+), 146 deletions(-)

-- 
2.30.2

