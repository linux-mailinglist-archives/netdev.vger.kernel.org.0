Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8139769824F
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjBORjN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Feb 2023 12:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBORjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:39:12 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51ED69748
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 09:39:11 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-JGpUwvYAMS617XiSpLG6dQ-1; Wed, 15 Feb 2023 12:38:51 -0500
X-MC-Unique: JGpUwvYAMS617XiSpLG6dQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 397183C0D873;
        Wed, 15 Feb 2023 17:38:50 +0000 (UTC)
Received: from hog (ovpn-195-113.brq.redhat.com [10.40.195.113])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A9622026D4B;
        Wed, 15 Feb 2023 17:38:48 +0000 (UTC)
Date:   Wed, 15 Feb 2023 18:37:00 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Frantisek Krenzelok <fkrenzel@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Apoorv Kothari <apoorvko@amazon.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH net-next v2 2/5] tls: block decryption when a rekey is
 pending
Message-ID: <Y+0YPEXNsvjUqBij@hog>
References: <cover.1676052788.git.sd@queasysnail.net>
 <4a9a82a0eaa47319e0e7a7fe525bd37f25b61cb5.1676052788.git.sd@queasysnail.net>
 <20230214210925.23c005b1@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230214210925.23c005b1@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-02-14, 21:09:25 -0800, Jakub Kicinski wrote:
> On Tue, 14 Feb 2023 12:17:39 +0100 Sabrina Dubroca wrote:
> > @@ -2141,6 +2178,12 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
> >  	if (err < 0)
> >  		return err;
> >  
> > +	/* a rekey is pending, let userspace deal with it */
> > +	if (unlikely(ctx->key_update_pending)) {
> > +		err = -EKEYEXPIRED;
> > +		goto splice_read_end;
> > +	}
> 
> This will prevent splicing peek()'ed data.
> Just put the check in tls_rx_rec_wait().

Ok, I'll do that and add a selftest for this sequence of syscalls.

-- 
Sabrina

