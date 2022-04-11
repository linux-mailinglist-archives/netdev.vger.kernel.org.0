Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BD84FC4F0
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348640AbiDKTVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbiDKTVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:21:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8230103B
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3F62B817AA
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADF5C385A3;
        Mon, 11 Apr 2022 19:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649704761;
        bh=kg9ubxDOlQ5G/2ECXAzzzFQS+WX48jpCY/ht3UC8Qo8=;
        h=From:To:Cc:Subject:Date:From;
        b=t6FSSnjodaaPsOqUt4wvOiwCrhmsmvnJSxN7cf8OXenUMG+PDqDtUshHqe+w+VlRQ
         Y26A2zwJAyddpZ2oyaF3f+/uXmcwyAr3qfbvsUPnHPF5n9KNxDFZfoGuQ65cDAplMb
         wiMnI6FtLl0VHzqHHByVNPlJgSJRriCDgN5amOw1N3O5cGDwozbWYYVIL9WJ+BBOAz
         OQIfHN+bqRugFUPysc/d1f4pPh4ZTsEUiNgw6VlhO++4VSfnUm6BQMPfjrxdyP0Raw
         WZB8Mks/hvn8gdWwNgiL0c2wrgpWSYbNWOxZJaX2FyW7szr3stM7n7JtUfsy8aMLMg
         L69k9igNF5wSg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/10] tls: rx: random refactoring part 3
Date:   Mon, 11 Apr 2022 12:19:07 -0700
Message-Id: <20220411191917.1240155-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS Rx refactoring. Part 3 of 3. This set is mostly around rx_list
and async processing. The last two patches are minor optimizations.
A couple of features to follow.

Jakub Kicinski (10):
  tls: rx: consistently use unlocked accessors for rx_list
  tls: rx: reuse leave_on_list label for psock
  tls: rx: move counting TlsDecryptErrors for sync
  tls: rx: don't handle TLS 1.3 in the async crypto callback
  tls: rx: assume crypto always calls our callback
  tls: rx: treat process_rx_list() errors as transient
  tls: rx: return the already-copied data on crypto error
  tls: rx: use async as an in-out argument
  tls: rx: use MAX_IV_SIZE for allocations
  tls: rx: only copy IV from the packet for TLS 1.2

 net/tls/tls_sw.c | 131 ++++++++++++++++++++++-------------------------
 1 file changed, 60 insertions(+), 71 deletions(-)

-- 
2.34.1

