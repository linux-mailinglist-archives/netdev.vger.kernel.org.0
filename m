Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4234F621F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbiDFOsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235089AbiDFOrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:47:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDA5102423
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 18:09:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CD0561920
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 01:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7051C385A1;
        Wed,  6 Apr 2022 01:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649207391;
        bh=i/dP04Ms0AuBJfVPYpjYX4lfOXz5aD7fJSy1gXE56dc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mfrc5l+TTj0wav/R/gJvOHCyQ6H3L1vsNYMxnR+FBl1KwpgItL4/JIOJK6I1AR4HR
         tkXCuD9wY32mX/a5+giAWG5Z1qtf1omAd66cR7vB2O0tq/BG0hQmbtfznadUDSCIKP
         BrpAyRGHGEXG2hTRYr1Hh8zXSd3eDWZESFO0rvE3YBZI+hUJ/nrq9LXjJsA6hOUU6J
         HrfGngj0HFVAqjtWngO3DjZk7zk+nnMaVUQfURMiBrj7+QztRwH25CNkakERQRjjYN
         XUVFqmYBM5bExEN3uHv2EHd7Z+wC7NnFA+vu2olooT3/7GokA04LrowTaf4u0uMSp9
         O0OwNC3xnSdrA==
Date:   Tue, 5 Apr 2022 18:09:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v3 net-next 0/2] net: tc: dsa: Implement offload of
 matchall for bridged DSA ports
Message-ID: <20220405180949.3dd204a1@kernel.org>
In-Reply-To: <20220404104826.1902292-1-mattias.forsblad@gmail.com>
References: <20220404104826.1902292-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Apr 2022 12:48:24 +0200 Mattias Forsblad wrote:
> Limitations
> If there is tc rules on a bridge and all the ports leave the bridge
> and then joins the bridge again, the indirect framwork doesn't seem
> to reoffload them at join. The tc rules need to be torn down and
> re-added.

You should unregister your callback when last DSA port leaves and
re-register when first joins. That way you'll get replay.

Also the code needs to check the matchall is highest prio.
