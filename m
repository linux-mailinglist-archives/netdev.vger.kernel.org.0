Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAE6652158
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiLTNTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiLTNTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:19:39 -0500
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB8C1261B
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 05:19:37 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 0D12A9C0868;
        Tue, 20 Dec 2022 08:19:37 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id RoeB0Np3Ziwb; Tue, 20 Dec 2022 08:19:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 9484A9C088E;
        Tue, 20 Dec 2022 08:19:36 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 9484A9C088E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1671542376; bh=vzyiusFH2uzN9rCvmatJUu/nhrrUlIuF7g+nf4auh5E=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=DMH2wpZXljjmQxVdNaW+WI5bNfNE5sZhW5+q3X82NvIRaxopw/gfvGW/wTC03fK5X
         wo6z56cZpXAd9LB3TmHJ8BjXIqAODs4GAoXU0dA+IcefjslMJXydSE4cuuySJPKCie
         k8AUOqXIN4oGOboIPTnG0w0JJqPbggD6bGo8jj6/AYKFUIFRH7EU+4b2w6IgNsDAw9
         znitKJcXDcaSYDNXaYwMyydvmCGjvp558SU/tAltzzOFa6ISeW+lF2JUkdqXoNq8Me
         jloAYg2facXWdNDcFwJSev++PNO0KvtWE4KCOciUodxcV7YorApAWp7TORDzSMz9xP
         2+iAM41r3hJTA==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VndFrcDqSRdl; Tue, 20 Dec 2022 08:19:36 -0500 (EST)
Received: from sfl-deribaucourt.rennes.sfl (mtl.savoirfairelinux.net [192.168.50.3])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id AE2199C0868;
        Tue, 20 Dec 2022 08:19:35 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     pabeni@redhat.com, woojung.huh@microchip.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v3 0/3] net: lan78xx: prevent LAN88XX specific operations
Date:   Tue, 20 Dec 2022 14:19:19 +0100
Message-Id: <20221220131921.806365-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series replaces lan78xx.c code specific to the LAN8835 phy wit=
h the
generic phy functions, making it compatible with other phys.

To that end, the exports of phy_disable_interrupts() and phy_enable_inter=
rupts()
needed to be refreshed.

