Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CE24ED33F
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 07:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiCaFff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 01:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiCaFfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 01:35:34 -0400
Received: from smtprz01.163.net (smtprz01.163.net [106.3.154.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7253104286
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 22:33:46 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 9164E44009E
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 13:33:45 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648704825; bh=R/GKA8fg0A1xmIXWtrQM8WHV2FCdOqYEpK5w1vjnWx4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z1i2Flc+yAz6KboBjV1ub4vDF/bDmMNTM4Vq9UWMQNdc9vgUV6wSZ2V9++fVYcawI
         KnZ98AxZKpb3glKi3jgD3zZlfAQvV8WnY4K0XN+TPV1XTPIgncRwZhSY3YWhhRDyRK
         6pHO+SOymmb8jJChobA7NQegYM2LC2Gx2u4Do644=
Received: from localhost (HELO smtprz01.163.net) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID -29291204
          for <netdev@vger.kernel.org>;
          Thu, 31 Mar 2022 13:33:45 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648704825; bh=R/GKA8fg0A1xmIXWtrQM8WHV2FCdOqYEpK5w1vjnWx4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z1i2Flc+yAz6KboBjV1ub4vDF/bDmMNTM4Vq9UWMQNdc9vgUV6wSZ2V9++fVYcawI
         KnZ98AxZKpb3glKi3jgD3zZlfAQvV8WnY4K0XN+TPV1XTPIgncRwZhSY3YWhhRDyRK
         6pHO+SOymmb8jJChobA7NQegYM2LC2Gx2u4Do644=
Received: from localhost (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id AAC541540B7C;
        Thu, 31 Mar 2022 13:33:42 +0800 (CST)
Date:   Thu, 31 Mar 2022 13:33:41 +0800
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH v2 2/3] nvme-tcp: support specifying the
 congestion-control
Message-ID: <20220331133341.00002f70@tom.com>
In-Reply-To: <15f24dcd-9a62-8bab-271c-baa9cc693d8d@grimberg.me>
References: <20220311103414.8255-1-sunmingbao@tom.com>
        <20220311103414.8255-2-sunmingbao@tom.com>
        <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
        <20220325201123.00002f28@tom.com>
        <b7b5106a-9c0d-db49-00ab-234756955de8@grimberg.me>
        <20220329104806.00000126@tom.com>
        <15f24dcd-9a62-8bab-271c-baa9cc693d8d@grimberg.me>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OOOPS, my mail service has got some issues.
Sorry for the duplicated emails.
