Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE8D225009
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgGSHWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgGSHWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:22:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8011EC0619D2;
        Sun, 19 Jul 2020 00:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=/pVp900Ln3sJSvHuAbv/SaWyFldF3beAINmVZ4HLysY=; b=sLiLcliWaUelfndYAann1EWVqv
        1lalGEfyXR+l40z0QBKq3FDJpd65Rq9UETb+FXYiDMcp0ROk5cKed4j6+cuZEoRQFPVVBO+UJwJEa
        2AyKm/r00fdiJs3obZIRV9tVnWRZaYFOJwJ70oI37ZkhlXD8pGZHvLVjyh/RTY9ZLES3AxvJ8MGxP
        YieIJcynsjH1ZlYxjxZHx70EXwfHH7R/mO/ZFMiGnTyEu5VLfN3IWhjIiZFaJIo1KT524DTFTCX+P
        Tzkb3P3W5LRR7Hm6pOvhXa6rc+HxF3Un2MhQ+DQ2f4sGkB0wjBJRBq4bmLA4e1JNED2dxD4skTD+N
        Cp0iek4Q==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3eX-0000PN-4X; Sun, 19 Jul 2020 07:22:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: do a single memdup_user in sctp_setsockopt v2
Date:   Sun, 19 Jul 2020 09:21:37 +0200
Message-Id: <20200719072228.112645-1-hch@lst.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

here is a resend of my series to lift the copy_from_user out of the
individual sctp sockopt handlers into the main sctp_setsockopt
routine.


Changes since v1:
 - fixes a few sizeof calls.
 - use memzero_explicit in sctp_setsockopt_auth_key instead of special
   casing it for a kzfree in the caller
 - remove some minor cleanups from sctp_setsockopt_autoclose to keep
   it closer to the existing version
 - add another little only vaguely related cleanup patch
