Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EEF678F01
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 04:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbjAXDbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 22:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjAXDbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 22:31:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F22AFF33;
        Mon, 23 Jan 2023 19:31:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C9F2B80EBB;
        Tue, 24 Jan 2023 03:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385BBC433EF;
        Tue, 24 Jan 2023 03:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674531075;
        bh=52LcSHf6xEYOVqWdOL6Bdpe8VfgKGj/xgXNv4t41+n4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YvSUhhMLq7KKq0nEmaqoxxTKdKY4c1V2UAYk1LR21PUxmJSVUurnDvdQ8cfmOiiVJ
         BTXBzcgAW/hlZ8TabOSpZVsQNyjwbgFiHfshBlH43Y3c6nehdOmH8N5XwXNYmVoYTw
         95LYv7eOAqgseKNKWm007w8euX1EnMSCCEf2C5MHtw2GIFk55/aqnOd/FOFjRigEQf
         UEN5PTT1bO2s8ExlZ3ppQuWyXIVIwJJTatR3POQOTV4w4lYrYIzDmtBuTVc0XluWi4
         pIoPnCOCkOQiEyfD0Z4GmQgjQxsu9upDx7tmhYmCQHOQ/Z4GhJsIlfZF+kEUI+9Eqv
         QDFoxLFiHEC+g==
Date:   Mon, 23 Jan 2023 19:31:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Laurent Vivier <lvivier@redhat.com>, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Cindy Lu <lulu@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eugenio =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>
Subject: Re: [PATCH 1/4] virtio_net: notify MAC address change on device
 initialization
Message-ID: <20230123193114.56aaec3a@kernel.org>
In-Reply-To: <07a24753-767b-4e1e-2bcf-21ec04bc044a@nvidia.com>
References: <20230122100526.2302556-1-lvivier@redhat.com>
        <20230122100526.2302556-2-lvivier@redhat.com>
        <07a24753-767b-4e1e-2bcf-21ec04bc044a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Jan 2023 15:47:08 +0200 Eli Cohen wrote:
> > @@ -3956,6 +3958,18 @@ static int virtnet_probe(struct virtio_device *vdev)
> >   	pr_debug("virtnet: registered device %s with %d RX and TX vq's\n",
> >   		 dev->name, max_queue_pairs);
> >   
> > +	/* a random MAC address has been assigned, notify the device */
> > +	if (dev->addr_assign_type == NET_ADDR_RANDOM &&  
> Maybe it's better to not count on addr_assign_type and use a local 
> variable to indicate that virtnet_probe assigned random MAC.

+1, FWIW
