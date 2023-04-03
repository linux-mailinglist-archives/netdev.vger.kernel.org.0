Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD716D41C2
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbjDCKTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbjDCKTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:19:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2A3C179
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 03:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680517090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ErhkLjTZo3sDNs+eNNONjk4AV6jR+dJPxKvHicqZOok=;
        b=H8PVoIhIsTKQ/Z16i2ecn4j4skUN0TdlBGC7Dwm3Cb4fpHfAXCC4PFH/63i6Mi+AHZIOeB
        1fO43z98P5ZoO26sR18l0Lw4MTOPe4VTMcSRZCazckGoQi/UYZpZ8MDju9s3FvQltM/4Sb
        0c9gj6MJ+HIyDouq1Pq/aZmd6riYIUo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-7fDF1a6ePI6gZGJaFAcJbg-1; Mon, 03 Apr 2023 06:18:06 -0400
X-MC-Unique: 7fDF1a6ePI6gZGJaFAcJbg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67B071C05147;
        Mon,  3 Apr 2023 10:18:06 +0000 (UTC)
Received: from localhost (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E766140EBF4;
        Mon,  3 Apr 2023 10:18:04 +0000 (UTC)
Date:   Mon, 3 Apr 2023 12:18:03 +0200
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] bonding: add software timestamping support
Message-ID: <ZCqn27fK9oIzfWCA@localhost>
References: <20230329031337.3444547-1-liuhangbin@gmail.com>
 <ZCQSf6Sc8A8E9ERN@localhost>
 <ZCUDFyNQoulZRsRQ@Laptop-X1>
 <7144.1680149564@famine>
 <ZCZUMzk5SM9swbDT@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCZUMzk5SM9swbDT@Laptop-X1>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 11:32:03AM +0800, Hangbin Liu wrote:
> On Wed, Mar 29, 2023 at 09:12:44PM -0700, Jay Vosburgh wrote:
> > 	If I'm reading things correctly, the answer is no, as one
> > exception appears to be IPOIB, which doesn't define .get_ts_info that I
> > CAN Find, and does not call skb_tx_timestamp() in ipoib_start_xmit().
> 
> Oh.. I thought it's a software timestamp and all driver's should support it.
> I didn't expect that Infiniband doesn't support it. Based on this, it seems
> we can't even assume that all Ethernet drivers will support it, since a
> private driver may also not call skb_tx_timestamp() during transmit. Even if
> we check the slaves during ioctl call, we can't expect a later-joined slave
> to have SW TX timestamp support. It seems that we'll have to drop this feature."

I'd not see that as a problem. At the time of the ioctl call the
information is valid. I think knowing that some timestamps will be
missing due to an interface not supporting the feature is a different
case than the admin later adding a new interface to the bond and
breaking the condition. The application likely already have some
expectations after it starts and configures timestamping, e.g. that
the RX filter is not changed or TX timestamping disabled.

-- 
Miroslav Lichvar

