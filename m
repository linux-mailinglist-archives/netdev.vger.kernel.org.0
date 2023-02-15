Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC3169820F
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjBORcG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Feb 2023 12:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjBORcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:32:05 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5BA26874
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 09:32:03 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-MZiEU821NGujPuqPa2Nd3A-1; Wed, 15 Feb 2023 12:31:42 -0500
X-MC-Unique: MZiEU821NGujPuqPa2Nd3A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39E39101A55E;
        Wed, 15 Feb 2023 17:31:41 +0000 (UTC)
Received: from hog (ovpn-195-113.brq.redhat.com [10.40.195.113])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 22980492B0E;
        Wed, 15 Feb 2023 17:31:37 +0000 (UTC)
Date:   Wed, 15 Feb 2023 18:29:50 +0100
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
Subject: Re: [PATCH net-next v2 0/5] tls: implement key updates for TLS1.3
Message-ID: <Y+0Wjrc9shLkH+Gg@hog>
References: <cover.1676052788.git.sd@queasysnail.net>
 <20230214210811.448b5ec4@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230214210811.448b5ec4@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

2023-02-14, 21:08:11 -0800, Jakub Kicinski wrote:
> On Tue, 14 Feb 2023 12:17:37 +0100 Sabrina Dubroca wrote:
> > Changes in v2
> > use reverse xmas tree ordering in tls_set_sw_offload and
> > do_tls_setsockopt_conf
> > turn the alt_crypto_info into an else if
> > selftests: add rekey_fail test
> > 
> > Vadim suggested simplifying tls_set_sw_offload by copying the new
> > crypto_info in the context in do_tls_setsockopt_conf, and then
> > detecting the rekey in tls_set_sw_offload based on whether the iv was
> > already set, but I don't think we can have a common error path
> > (otherwise we'd free the aead etc on rekey failure). I decided instead
> > to reorganize tls_set_sw_offload so that the context is unmodified
> > until we know the rekey cannot fail. Some fields will be touched
> > during the rekey, but they will be set to the same value they had
> > before the rekey (prot->rec_seq_size, etc).
> > 
> > Apoorv suggested to name the struct tls_crypto_info_keys "tls13"
> > rather than "tls12". Since we're using the same crypto_info data for
> > TLS1.3 as for 1.2, even if the tests only run for TLS1.3, I'd rather
> > keep the "tls12" name, in case we end up adding a
> > "tls13_crypto_info_aes_gcm_128" type in the future.
> > 
> > Kuniyuki and Apoorv also suggested preventing rekeys on RX when we
> > haven't received a matching KeyUpdate message, but I'd rather let
> > userspace handle this and have a symmetric API between TX and RX on
> > the kernel side. It's a bit of a foot-gun, but we can't really stop a
> > broken userspace from rolling back the rec_seq on an existing
> > crypto_info either, and that seems like a worse possible breakage.
> 
> And how will we handle re-keying in offload?

Sorry for the stupid question... do you mean that I need to solve that
problem before this series can progress, or that the cover letter
should summarize the state of the discussion?

> >  include/net/tls.h                 |   4 +
> >  net/tls/tls.h                     |   3 +-
> >  net/tls/tls_device.c              |   2 +-
> >  net/tls/tls_main.c                |  37 +++-
> >  net/tls/tls_sw.c                  | 189 +++++++++++++----
> >  tools/testing/selftests/net/tls.c | 336 +++++++++++++++++++++++++++++-
> 
> Documentation please.

Ok, I'll add a paragraph to Documentation/networking/tls.rst in the
next version.

-- 
Sabrina

