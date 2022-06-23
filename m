Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7213B557D44
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiFWNrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiFWNrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:47:03 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941CB263;
        Thu, 23 Jun 2022 06:47:02 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id C57C39C024D;
        Thu, 23 Jun 2022 09:47:01 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id szNayX9ADv7O; Thu, 23 Jun 2022 09:47:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 55E949C0252;
        Thu, 23 Jun 2022 09:47:01 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 55E949C0252
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1655992021; bh=xHOReytFLWmyQdad2YjjUZiwU/ThBt0PZTMrvgabmX0=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=eYHkH3jvad4vcgvd5C7UTDRy9+ZcuxsprIoQLAmU/U2/sut03KuumS93p81DLoyEi
         cxbf2z7yK2OApimdzVNtakLP5CYCRkFq615HLIAfWNCLHZg1NXcCN1IXnfuX15HErP
         O9MmrszP6UJGvnwXih2V/zSawAvGYOYOhJeNyq7iuIn010aSzRl03DzI+SWADt1XS5
         Arde3E2/3iRzXwjJv3TQDxK6Xpcm2no1M7n5qfAvbrZ0nQYJloA63aXkVLfIvcMLxa
         +QZUc1QpqEaTf5pZ/4scu2XctdTLO7S26tnI30xLWhH4++hfZ1sr/wDrX9MwAdnNiJ
         dQE4Z55CNkcIA==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id F4cd6FXqs8Vb; Thu, 23 Jun 2022 09:47:01 -0400 (EDT)
Received: from sfl-deribaucourt.rennes.sfl (lfbn-ren-1-676-174.w81-53.abo.wanadoo.fr [81.53.245.174])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 5A8DC9C024D;
        Thu, 23 Jun 2022 09:47:00 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com
Subject: [PATCH v3 0/2] net: dp83822: fix interrupt floods
Date:   Thu, 23 Jun 2022 15:46:43 +0200
Message-Id: <20220623134645.1858361-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YqzAKguRaxr74oXh@lunn.ch>
References: <YqzAKguRaxr74oXh@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The false carrier and RX error counters, once half full, produce interrup=
t
floods. Since we do not use these counters, these interrupts should be di=
sabled.

v2: added Fixes: and patchset description 0/2
v3: Fixed Fixes: commit format

In-Reply-To: YqzAKguRaxr74oXh@lunn.ch
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")

