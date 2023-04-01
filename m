Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390676D2E28
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbjDAE00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjDAE0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:26:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4A91E713;
        Fri, 31 Mar 2023 21:26:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3630361924;
        Sat,  1 Apr 2023 04:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60991C433D2;
        Sat,  1 Apr 2023 04:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680323183;
        bh=g5OXxn6VSpzyfmEVpzQPnAo4G3AknW/LtV8X932z1AY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XLSXDD/+oG6Zwn8ARpvW7dAYxLywQnaS6IRQ94R8f+0qYiEn2n4MC0es/eYWKnv+r
         N7XuDgvAfrBfR3wnHatwIDJx3cRfmDPZXTnGVTGjgCE3rmGd0GqLeTdkffNaH38Sdm
         0EQBKwM1DlR17xA9XcKgo1bdLelDwdPogxJXWJlq1MCj+uTqFnFX3DB0uAnTCUeti/
         1cF32OPylAyhsnttQYVCU+Y/oH5td0B3a6R+uYuv29ptUYi6rRw3nipfA/YkxCYn0J
         Ki7cBFeh4ztYAcQsMoPj//EbjUB9OTqJY/wYVnS3dA0mRdSKH6g5yga7JO2ILaAvQj
         OaTvk1+MUJLGw==
Date:   Fri, 31 Mar 2023 21:26:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Huettner <felix.huettner@mail.schwarz>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, luca.czesla@mail.schwarz
Subject: Re: [PATCH] net: openvswitch: fix race on port output
Message-ID: <20230331212622.44256513@kernel.org>
In-Reply-To: <ZCaXfZTwS9MVk8yZ@kernel-bug-kernel-bug>
References: <ZCaXfZTwS9MVk8yZ@kernel-bug-kernel-bug>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 08:19:09 +0000 Felix Huettner wrote:
> 1. An openvswitch instance with one bridge and default flows
> 2. two network namespaces "server" and "client"
> 3. two ovs interfaces "server" and "client" on the bridge
> 4. for each ovs interface a veth pair with a matching name and 32 rx and
>    tx queues
> 5. move the ends of the veth pairs to the respective network namespaces
> 6. assign ip addresses to each of the veth ends in the namespaces (needs
>    to be the same subnet)
> 7. start some http server on the server network namespace
> 8. test if a client in the client namespace can reach the http server

grunt.. please read:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
