Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3955860EB05
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 23:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbiJZV5T convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Oct 2022 17:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbiJZV5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 17:57:18 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DEE993A3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 14:57:16 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-tjqbcbDXP9mu3QhXRHCBDQ-1; Wed, 26 Oct 2022 17:57:09 -0400
X-MC-Unique: tjqbcbDXP9mu3QhXRHCBDQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3D3029AA2E7;
        Wed, 26 Oct 2022 21:57:08 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 694A01121339;
        Wed, 26 Oct 2022 21:57:07 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Leon Romanovsky <leon@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net v2 0/5] macsec: offload-related fixes
Date:   Wed, 26 Oct 2022 23:56:22 +0200
Message-Id: <cover.1666793468.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm working on a dummy offload for macsec on netdevsim. It just has a
small SecY and RXSC table so I can trigger failures easily on the
ndo_* side. It has exposed a couple of issues.

The first patch is a revert of commit c850240b6c41 ("net: macsec:
report real_dev features when HW offloading is enabled"). That commit
tried to improve the performance of macsec offload by taking advantage
of some of the NIC's features, but in doing so, broke macsec offload
when the lower device supports both macsec and ipsec offload, as the
ipsec offload feature flags were copied from the real device. Since
the macsec device doesn't provide xdo_* ops, the XFRM core rejects the
registration of the new macsec device in xfrm_api_check.

I'm working on re-adding those feature flags when offload is
available, but I haven't fully solved that yet. I think it would be
safer to do that second part in net-next considering how complex
feature interactions tend to be.

v2:
 - better describe the issue introduced by commit c850240b6c41 (Leon
   Romanovsky)
 - drop unnecessary !! (Leon Romanovsky)

Sabrina Dubroca (5):
  Revert "net: macsec: report real_dev features when HW offloading is
    enabled"
  macsec: delete new rxsc when offload fails
  macsec: fix secy->n_rx_sc accounting
  macsec: fix detection of RXSCs when toggling offloading
  macsec: clear encryption keys from the stack after setting up offload

 drivers/net/macsec.c | 51 ++++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 33 deletions(-)

-- 
2.38.0

