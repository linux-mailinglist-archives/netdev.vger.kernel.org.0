Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCE150B7B9
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 14:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447627AbiDVM7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 08:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385908AbiDVM7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 08:59:06 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Apr 2022 05:56:11 PDT
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0791F39827
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 05:56:10 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 9660 invoked from network); 22 Apr 2022 14:49:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1650631768; bh=FzlZWuqpqT4dYFKX9UTFhTlZBNM1KD7eyT6+7FMZ7dE=;
          h=From:To:Cc:Subject;
          b=LX5BduKUebu3hJxINq1D1+qf6qLFbjcnrYFczjeHyWDF21d4ZNp3KMtgh/ZO59IuW
           176w9+1k6cc3bY3PnD0nfiFiQidj2elSJVZ1gPG49qhwkrp3Hsni6a56uNDGC0iBii
           vi71ZUiwj/gEayxBxzHj38pEctRjyTe2f1jKp4fU=
Received: from unknown (HELO kicinski-fedora-PC1C0HJN) (kubakici@wp.pl@[163.114.132.6])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <kvalo@kernel.org>; 22 Apr 2022 14:49:28 +0200
Date:   Fri, 22 Apr 2022 05:49:19 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Bernard Zhao <zhaojunkui2008@126.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        bernard@vivo.com
Subject: Re: [PATCH] mediatek/mt7601u: add debugfs exit function
Message-ID: <20220422054919.6f056300@kicinski-fedora-PC1C0HJN>
In-Reply-To: <87k0bhmuh6.fsf@kernel.org>
References: <20220422070325.465918-1-zhaojunkui2008@126.com>
        <87k0bhmuh6.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: cfadbedbb822125ed36bbc0826aae61a
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [4eNk]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Apr 2022 10:45:57 +0300 Kalle Valo wrote:
> > When mt7601u loaded, there are two cases:
> > First when mt7601u is loaded, in function mt7601u_probe, if
> > function mt7601u_probe run into error lable err_hw,
> > mt7601u_cleanup didn`t cleanup the debugfs node.
> > Second when the module disconnect, in function mt7601u_disconnect,
> > mt7601u_cleanup didn`t cleanup the debugfs node.
> > This patch add debugfs exit function and try to cleanup debugfs
> > node when mt7601u loaded fail or unloaded.

Is this actually needed?  Looks like wireless has a wiphy debugfs dir
now, so the entire thing should get removed recursively when probe
fails. The driver is not doing anything special.

> > diff --git a/drivers/net/wireless/mediatek/mt7601u/debugfs.c b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
> > index 20669eacb66e..1ae3d75d3c9b 100644
> > --- a/drivers/net/wireless/mediatek/mt7601u/debugfs.c
> > +++ b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
> > @@ -124,17 +124,22 @@ DEFINE_SHOW_ATTRIBUTE(mt7601u_eeprom_param);
> >  
> >  void mt7601u_init_debugfs(struct mt7601u_dev *dev)
> >  {
> > -	struct dentry *dir;
> > -
> > -	dir = debugfs_create_dir("mt7601u", dev->hw->wiphy->debugfsdir);
> > -	if (!dir)
> > +	dev->root_dir = debugfs_create_dir("mt7601u", dev->hw->wiphy->debugfsdir);
> > +	if (!dev->root_dir)
> >  		return;
