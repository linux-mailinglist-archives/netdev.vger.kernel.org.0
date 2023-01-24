Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233CA67914E
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbjAXGxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjAXGxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:53:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D0A3346A;
        Mon, 23 Jan 2023 22:53:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00E3EB810D9;
        Tue, 24 Jan 2023 06:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27938C433D2;
        Tue, 24 Jan 2023 06:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674543224;
        bh=nHpHX6/+wyWuj2Y4QnlYm5vYfNUU5MLJAuaOKbp/Gq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LAbcsySmTVzlG0xf2zn8yImJgdNeKCR/+1QBKBPvSMp3Q57GyB4dSorot4n32MTOL
         lpwbFZnOAaKAJ7eYkyC0HVbi+p5Halld2qmO21+JijiErymUOaWSEPj28tty01wE50
         SS1DHyBEVdStkdXxXaAl1I4wMYdOf13o9RL6Rkc1A8ViqsPOJfhrVPv486KNxIPoR2
         P+x1FlC5N9UPCpxaCzZTLSQHG/jC+mcbUiQ8UIMthIjKcKI6HNkw6X4xozn/H+scU4
         h2RPdYdQn/8J9QTQzJWU/01F8wnkqfj3OD/o4btPng6E1TGsSBRTAo8L1ebWHr42Bf
         Ojv5KYbgTKv5A==
Date:   Tue, 24 Jan 2023 08:49:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com
Subject: Re: [PATCH net-next v8 1/8] bnxt_en: Add auxiliary driver support
Message-ID: <Y89/b4kdiXlFzkOl@unreal>
References: <20230120060535.83087-1-ajit.khaparde@broadcom.com>
 <20230120060535.83087-2-ajit.khaparde@broadcom.com>
 <20230123223305.30c586ee@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123223305.30c586ee@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 10:33:05PM -0800, Jakub Kicinski wrote:
> On Thu, 19 Jan 2023 22:05:28 -0800 Ajit Khaparde wrote:
> > @@ -13212,6 +13214,7 @@ static void bnxt_remove_one(struct pci_dev *pdev)
> >  	kfree(bp->rss_indir_tbl);
> >  	bp->rss_indir_tbl = NULL;
> >  	bnxt_free_port_stats(bp);
> > +	bnxt_aux_priv_free(bp);
> >  	free_netdev(dev);
> 
> You're still freeing the memory in which struct device sits regardless
> of its reference count.

BTW, Ajit does the same wrong kfree in bnxt_rdma_aux_device_add() too.
+	ret = auxiliary_device_add(aux_dev);
+	if (ret)
+		goto aux_dev_uninit;
+
...
+aux_dev_uninit:
+	auxiliary_device_uninit(aux_dev);
+free_edev:
+	kfree(edev); <----- wrong
+	bp->edev = NULL;

Thanks
