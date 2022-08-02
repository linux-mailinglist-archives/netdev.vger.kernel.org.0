Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FD7587EE2
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 17:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiHBPTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 11:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiHBPTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 11:19:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7609A107;
        Tue,  2 Aug 2022 08:19:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6FA060AC3;
        Tue,  2 Aug 2022 15:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABED2C433D7;
        Tue,  2 Aug 2022 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659453578;
        bh=uIFHKVSnF63qKOrJUUCg7Hh718c66h+z7U+n3VkILOM=;
        h=From:To:Cc:Subject:Date:From;
        b=AThHoG2+PQtHaYN+tDY1EeVpqjl0XE6wDIbyWq6gpC5cvOJ/BsomTeBrbF2OOZeIg
         dYEJInlN9fMR4jjXbQ/BxE97M4cKRZmZSriMJ/575LoH+OGWVD2RdFeKU5VTLLr4Gc
         Jz3Ws8pyyRhHEorO3lFPayYSPPoSgOdEvTiNygu1I7muGHcwk5hV6Gxkp5WuZ9VCN/
         IATomtJHoDnkdeLwjqsLvh+NvNbhczoZHqv2Lg5/2bO55tzCJHtXqBSRJve9RxRh3D
         TQsjD/45mPX7gX1a46kgOB4nKhj2SNMKTtT8uq+q3n9W0zNYRan2PoP16zm7hd/lzJ
         syGLo+RJZF0rQ==
From:   broonie@kernel.org
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Date:   Tue,  2 Aug 2022 16:19:32 +0100
Message-Id: <20220802151932.2830110-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/ax25/af_ax25.c

between commit:

  d7c4c9e075f8c ("ax25: fix incorrect dev_tracker usage")

from the net tree and commit:

  d62607c3fe459 ("net: rename reference+tracking helpers")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc net/ax25/af_ax25.c
index 5b5363c99ed50,bbac3cb4dc99d..0000000000000
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@@ -102,7 -102,8 +102,8 @@@ again
  			ax25_disconnect(s, ENETUNREACH);
  			s->ax25_dev = NULL;
  			if (sk->sk_socket) {
- 				dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
+ 				netdev_put(ax25_dev->dev,
 -					   &ax25_dev->dev_tracker);
++					   &ax25->dev_tracker);
  				ax25_dev_put(ax25_dev);
  			}
  			ax25_cb_del(s);
@@@ -1065,7 -1066,7 +1066,7 @@@ static int ax25_release(struct socket *
  			del_timer_sync(&ax25->t3timer);
  			del_timer_sync(&ax25->idletimer);
  		}
- 		dev_put_track(ax25_dev->dev, &ax25->dev_tracker);
 -		netdev_put(ax25_dev->dev, &ax25_dev->dev_tracker);
++		netdev_put(ax25_dev->dev, &ax25->dev_tracker);
  		ax25_dev_put(ax25_dev);
  	}
  
@@@ -1146,7 -1147,7 +1147,7 @@@ static int ax25_bind(struct socket *soc
  
  	if (ax25_dev) {
  		ax25_fillin_cb(ax25, ax25_dev);
- 		dev_hold_track(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
 -		netdev_hold(ax25_dev->dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
++		netdev_hold(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
  	}
  
  done:
