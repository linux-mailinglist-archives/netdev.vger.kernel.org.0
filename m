Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D18854E8F3
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244033AbiFPR4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243374AbiFPR4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:56:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 504AC4ECF1
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655402169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7bQvwIYLBHjziuX1bKgnxc2eIaq6KR/tZE4lo8qSOIg=;
        b=CwjaTQ9jZdSAI32EPXsoARutsA6A12KUuwoq/OoGxdZtMcEvKf0ktUyEKNC/M1XR8JGZgl
        t2ZSfAjq16bTHozMPNXPb6dKBFTqrVp/ZR6VGumRpxZzKzwXg1VWZiSVMf62Su5Dz66+JH
        vpkZa7Vnly+SW0P9Y6TfGJmEVGhMNQg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-Nf7ji3YXOneCsMxRCpW3ww-1; Thu, 16 Jun 2022 13:56:04 -0400
X-MC-Unique: Nf7ji3YXOneCsMxRCpW3ww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84F0F811E75;
        Thu, 16 Jun 2022 17:56:04 +0000 (UTC)
Received: from p1.luc.cera.cz (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BBCE2026985;
        Thu, 16 Jun 2022 17:56:03 +0000 (UTC)
Date:   Thu, 16 Jun 2022 19:56:02 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Daniel Juarez <djuarezg@cern.ch>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool] sff-8079/8472: Fix missing sff-8472 output in
 netlink path
Message-ID: <20220616195602.2bbfab8d@p1.luc.cera.cz>
In-Reply-To: <20220616161945.eofmu3l4kzy77bb6@lion.mk-sys.cz>
References: <20220616155009.3609572-1-ivecera@redhat.com>
        <20220616161945.eofmu3l4kzy77bb6@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,PP_MIME_FAKE_ASCII_TEXT,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 18:19:45 +0200
Michal Kubecek <mkubecek@suse.cz> wrote:

> On Thu, Jun 16, 2022 at 05:50:09PM +0200, Ivan Vecera wrote:
> > Commit 5b64c66f58d ("ethtool: Add netlink handler for
> > getmodule (-m)") provided a netlink variant for getmodule
> > but also introduced a regression as netlink output is different
> > from ioctl output that provides information from A2h page
> > via sff8472_show_all().
> > 
> > To fix this the netlink path should check a presence of A2h page
> > by value of bit 6 in byte 92 of page A0h and if it is set then
> > get A2h page and call sff8472_show_all().
> > 
> > Fixes: 5b64c66f58d ("ethtool: Add netlink handler for getmodule (-m)")  
> 
> Looks like the leading "2" in commit id got lost and "^M" got into the
> subject somehow. AFAICS this should be
> 
>   Fixes: 25b64c66f58d ("ethtool: Add netlink handler for getmodule (-m)")
> 
> Michal

Will send v2

Ivan

