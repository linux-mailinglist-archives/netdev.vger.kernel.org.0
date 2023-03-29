Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5F36CD7A4
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 12:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjC2K2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 06:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjC2K2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 06:28:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370E71BFC
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 03:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680085637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jd7WBwFIrNLOyJKQG/L4vTAs7GOnPYLmwP2mwUTLNMw=;
        b=HOZccEbq8Ev4foRutDJWD7BAyO5CT/PUhUAB9kJTAcQcBaP5tYGMSxOA6ch6EqhEzkih95
        xl9h31cTQxFi6bh9syAEFeG8cMW/ZMv0Br10mRYFGtW+3GLhUo0wJP6uk/VQz4joysNVaf
        TagPYpqPxUbZzbft1JNIlxqcm9L+c2Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-uxOw9QE-NcyUG3HLHH_hbw-1; Wed, 29 Mar 2023 06:27:14 -0400
X-MC-Unique: uxOw9QE-NcyUG3HLHH_hbw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CFF38030D1;
        Wed, 29 Mar 2023 10:27:13 +0000 (UTC)
Received: from localhost (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25E34492B00;
        Wed, 29 Mar 2023 10:27:12 +0000 (UTC)
Date:   Wed, 29 Mar 2023 12:27:11 +0200
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] bonding: add software timestamping support
Message-ID: <ZCQSf6Sc8A8E9ERN@localhost>
References: <20230329031337.3444547-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329031337.3444547-1-liuhangbin@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 11:13:37AM +0800, Hangbin Liu wrote:
> At present, bonding attempts to obtain the timestamp (ts) information of
> the active slave. However, this feature is only available for mode 1, 5,
> and 6. For other modes, bonding doesn't even provide support for software
> timestamping. To address this issue, let's call ethtool_op_get_ts_info
> when there is no primary active slave. This will enable the use of software
> timestamping for the bonding interface.

Would it make sense to check if all devices in the bond support
SOF_TIMESTAMPING_TX_SOFTWARE before returning it for the bond?
Applications might expect that a SW TX timestamp will be always
provided if the capability is reported.

-- 
Miroslav Lichvar

