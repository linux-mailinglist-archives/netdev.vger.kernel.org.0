Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEEB1FEE22
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 10:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgFRIyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 04:54:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45763 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728924AbgFRIyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 04:54:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592470440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ovkYsmI8BRXmsAYqJddQDzFh7DA+RFowUgs/p4NZFfs=;
        b=Kyk1EbM1sVpbrmqFYCr0q8ddEdGh2lF7ItJVHhmVlIed/QmNCcJufNO0f4BNDk65NlUERJ
        RAY2pd98GKKS7iwsYNDJX5FE+dTQ2GFSXSi7GaST/gYxFOYitxfKefcHpT6R2mTycD3QJB
        0pzL9KLwZRf/TUqlkj/pTbuIuVVRFvU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-BXdbGOpGM9GJ1YwAG5q-zA-1; Thu, 18 Jun 2020 04:53:56 -0400
X-MC-Unique: BXdbGOpGM9GJ1YwAG5q-zA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A449B801504;
        Thu, 18 Jun 2020 08:53:54 +0000 (UTC)
Received: from new-host-5 (unknown [10.40.193.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2763810013C0;
        Thu, 18 Jun 2020 08:53:51 +0000 (UTC)
Message-ID: <4c1589d4d2866cdfebf12bb32434210532b3b884.camel@redhat.com>
Subject: Re: [PATCH net] tc-testing: fix geneve options match in tunnel_key
 unit tests
From:   Davide Caratti <dcaratti@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>,
        Lucas Bates <lucasb@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        David Miller <davem@davemloft.net>, lucien.xin@gmail.com
In-Reply-To: <20200618083705.449619-1-liuhangbin@gmail.com>
References: <20200618083705.449619-1-liuhangbin@gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 18 Jun 2020 10:53:51 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-18 at 16:37 +0800, Hangbin Liu wrote:
> tc action print "geneve_opts" instead of "geneve_opt".
> Fix the typo, or we will unable to match correct action output.
> 

hello Hangbin,

> Fixes: cba54f9cf4ec ("tc-testing: add geneve options in tunnel_key unit tests")

this Fixes: tag is suspicious, when a tdc test is added I would expect to
see it passing. If I well read the code, the problem has been introduced
in iproute2, with commit 

commit f72c3ad00f3b7869e90840d0098a83cb88224892
Author: Xin Long <lucien.xin@gmail.com>
Date:   Mon Apr 27 18:27:48 2020 +0800

    tc: m_tunnel_key: add options support for vxlan
    

that did:

[...]

static void tunnel_key_print_geneve_options(const char *name,
-                                           struct rtattr *attr)
+static void tunnel_key_print_geneve_options(struct rtattr *attr)
 {
        struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX + 1];
        struct rtattr *i = RTA_DATA(attr);
        int ii, data_len = 0, offset = 0;
        int rem = RTA_PAYLOAD(attr);
+       char *name = "geneve_opts";
        char strbuf[rem * 2 + 1];
        char data[rem * 2 + 1];
        uint8_t data_r[rem];
@@ -421,7 +464,7 @@ static void tunnel_key_print_geneve_options(const char *name,
 
        open_json_array(PRINT_JSON, name);
        print_nl();
-       print_string(PRINT_FP, name, "\t%s ", "geneve_opt");
+       print_string(PRINT_FP, name, "\t%s ", name);
 

(just speculating, because I didn't try older versions of iproute2). But if my
hypothesis is correct, then the fix should be done in iproute2, WDYT?

thanks,
-- 
davide



