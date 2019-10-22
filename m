Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BB4E068B
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbfJVOfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:35:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56757 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726915AbfJVOfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571754950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/n2eHQ0p4j1SYBeVk8R44Nl2uhDop20VexokYV/65Pk=;
        b=BjjWTjSoG1L9LBufxJcq818YC2OiiiovJBSxzxIcbbd+h95Q1Xq0eLPDQ/Aw+K1MFyCdbC
        N0p10IMZwCQqPSvOuAw8FqbmP8GxU09wTtjjboMrq0yCQvOrP3MpO1igIFL5/WuZmNOT2v
        oKO+O0cSDXsRoD3hCgrEs+ryf8rQeiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309--kpW7cl-O-yagiNReOeiHA-1; Tue, 22 Oct 2019 10:35:46 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52538107AD33;
        Tue, 22 Oct 2019 14:35:42 +0000 (UTC)
Received: from localhost.localdomain (ovpn-121-180.rdu2.redhat.com [10.10.121.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C833952CC;
        Tue, 22 Oct 2019 14:35:41 +0000 (UTC)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id A825AC0AAD; Tue, 22 Oct 2019 11:35:39 -0300 (-03)
Date:   Tue, 22 Oct 2019 11:35:39 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, dcaratti@redhat.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Message-ID: <20191022143539.GY4321@localhost.localdomain>
References: <20191022141804.27639-1-vladbu@mellanox.com>
MIME-Version: 1.0
In-Reply-To: <20191022141804.27639-1-vladbu@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: -kpW7cl-O-yagiNReOeiHA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 05:17:51PM +0300, Vlad Buslov wrote:
> Currently, significant fraction of CPU time during TC filter allocation
> is spent in percpu allocator. Moreover, percpu allocator is protected
> with single global mutex which negates any potential to improve its
> performance by means of recent developments in TC filter update API that
> removed rtnl lock for some Qdiscs and classifiers. In order to
> significantly improve filter update rate and reduce memory usage we
> would like to allow users to skip percpu counters allocation for
> specific action if they don't expect high traffic rate hitting the
> action, which is a reasonable expectation for hardware-offloaded setup.
> In that case any potential gains to software fast-path performance
> gained by usage of percpu-allocated counters compared to regular integer
> counters protected by spinlock are not important, but amount of
> additional CPU and memory consumed by them is significant.

Yes!

I wonder how this can play together with conntrack offloading.  With
it the sw datapath will be more used, as a conntrack entry can only be
offloaded after the handshake.  That said, the host can have to
process quite some handshakes in sw datapath.  Seems OvS can then just
not set this flag in act_ct (and others for this rule), and such cases
will be able to leverage the percpu stats.  Right?

> allocator, but not for action idr lock, which is per-action. Note that
> percpu allocator is still used by dst_cache in tunnel_key actions and
> consumes 4.68% CPU time. Dst_cache seems like good opportunity for
> further insertion rate optimization but is not addressed by this change.

I vented this idea re dst_cache last week with Paolo. He sent me a
draft patch but I didn't test it yet.

Thanks,
Marcelo

