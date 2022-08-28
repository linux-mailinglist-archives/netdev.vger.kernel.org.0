Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3E25A3F42
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 21:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiH1TTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 15:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiH1TTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 15:19:42 -0400
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776C822531
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 12:19:39 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 10403 invoked from network); 28 Aug 2022 21:19:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1661714373; bh=/eUKG1umm5zTG09oNzgSYhbtpyRyJqmQWr3I7RCStgg=;
          h=From:To:Cc:Subject;
          b=kv2pLwMQtoDWVuLCjdjbZlDZM6c3sTP8r1odVgNZ1XmD/TR64+QqswvZZfLfMIHjr
           cAeYp9ZqIkRml6PruDtIKaY42eJNX7XVC9Vg+Syf+TqP1s1qBGSrfIgx9/uvTu+cB6
           a/nEf4fvvdCi77Tled5EwWRVqLCuPkPGaN+72Iio=
Received: from ip-137-21.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.21])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 28 Aug 2022 21:19:33 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH net-next v2 0/1] net: lantiq_xrx200: use skb cache
Date:   Sun, 28 Aug 2022 21:19:30 +0200
Message-Id: <20220828191931.4923-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: fa6ffa8f359bf4fb939cd12384309860
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [UcPE]                               
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi_build_skb() reuses NAPI skbuff_head cache in order to save some
cycles on freeing/allocating skbuff_heads on every new Rx or completed
Tx.
Use napi_consume_skb() to feed the cache with skbuff_heads of completed
Tx. The budget parameter is added to indicate NAPI context, as a value
of zero can be passed in the case of netpoll.

Changelog:

  v2:
  - rebased patch to avoid conflicts

Aleksander Jan Bajkowski (1):
  net: lantiq_xrx200: use skb cache

 drivers/net/ethernet/lantiq_xrx200.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.30.2

