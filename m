Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720A7617C2C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 13:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbiKCMJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 08:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiKCMJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 08:09:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10569FCF;
        Thu,  3 Nov 2022 05:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Subject:Cc:To:From:Date:Message-ID:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=4jCdzdEgKJMqfguFXzmLkmfG4D81anvgaurHlpLDyOk=; b=JHs1z4axWH2GPoZTKoZtohizp4
        Wtywg/cyVEHbjeBvtjwYVoiQdcDmBpxNXqs6n0RABGZEqtEXhkf4yzyAwZ2yE/gtrhnEuxanzDbha
        4WEyUiCkNQgDVcz4AUDyDINctf3nOErtR4ma/VLlSbElWGiD6mgxecLMXbNMAyp5C8RrZvGk5PWQt
        hgmAg7I81g5TE7Bjp96n2hjVcbdD6+iWl/G1LTL9eQuXx+W0Ggg6SdQsrz+5eiN3MQiHqZuoOKbve
        ip8rqLkzd6OKmabl3Okdvnh6OJlLjSQ0YUJwJPOZfqV/ABPcFA+++NbWE9JCiymY03EhOrBXYTDST
        HuZP+l2A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqZ1g-006RMV-9H; Thu, 03 Nov 2022 12:08:52 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2DB6730026A;
        Thu,  3 Nov 2022 13:08:44 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 80BF520AB9A11; Thu,  3 Nov 2022 13:08:44 +0100 (CET)
Message-ID: <20221103120012.717020618@infradead.org>
User-Agent: quilt/0.66
Date:   Thu, 03 Nov 2022 13:00:12 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     olsajiri@gmail.com, ast@kernel.org, daniel@iogearbox.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, peterz@infradead.org, bjorn@kernel.org,
        toke@redhat.com, David.Laight@aculab.com, rostedt@goodmis.org
Subject: [PATCH 0/2] bpf: Yet another approach to fix the BPF dispatcher thing
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Even thought the __attribute__((patchable_function_entry())) solution to the
BPF dispatcher woes works, it turns out to not be supported by the whole range
of ageing compilers we support. Specifically this attribute seems to be GCC-8
and later.

This is another approach -- using static_call() to rewrite the dispatcher
function. I've compile tested this on:

  x86_64  (inline static-call support)
  i386    (out-of-line static-call support)
  aargh64 (no static-call support)

A previous version was tested and found working by Bjorn.

It is split in two patches; first reverting the current approach and then
introducing the new for ease of review.

