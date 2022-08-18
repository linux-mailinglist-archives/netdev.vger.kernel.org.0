Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09A45988E4
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245538AbiHRQ3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344681AbiHRQ3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:29:47 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF195FF45
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:29:45 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id tl27so4240578ejc.1
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=krose.org; s=google;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=WSbcGuyflvw/fizHYHaMNKx156Drf2+/VdKc9jxbFxk=;
        b=N3yiv0xSAqOorK2B8E6pq/IGwDsy4wk3kSkHXnb5WvsHyBTBQyeBKKf3hmmpru45A5
         kqEx33yac1xZ9CsKhy92i9NZWy/6FU9hqpoB84HIwJCll2uqXBwrVtUoB5wIEiw+awdz
         mNs3V6Z21d9MIyE65dWGLKjSGupAuLCfr5kks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=WSbcGuyflvw/fizHYHaMNKx156Drf2+/VdKc9jxbFxk=;
        b=tcuwij8DshWj9VvpO6aVQY8LeiRtzLEHKIyBU2VikWvYVFHV+/mXCvdksN8nwfnpiD
         P+OFmSdC4jddBopkxwh2BJe0F171VBLd+H1q5Uy5rNcKG4k/Z2a2c0cxIMyf8RHpa6xv
         P8gqX3wW8VFpyVQBriDA8CJKoVI+1bPdN/hT/ElYeDf7dos1cSIViH8u+WopxUMHlqeC
         X1GhIKKBVwyST3HtzrM35iGyGicyDd5fX5RNkj8A+NNmItDILqO0rx+Id/As0eNvfDFd
         A2r6ludni2X7fs1e3StAkHMZOnFAu45IoDCOldyP4Q8STFlgQyRbz+8Ou6wUjFRSszeT
         GzjQ==
X-Gm-Message-State: ACgBeo1sh6G9EiAus+uGcc9efWQg5W3F/TCxEp+fN+09R4lX7czdSwEC
        FLsODaPRntzeVGUzRMRVXvJaBlnIUXWFcDasjdFyeGrYhPKA+g==
X-Google-Smtp-Source: AA6agR7k8uOIldjEN76asScnsY1rfra7qjh4vufnH6zUJVwxNHR3E/zUBDe965dxH+uNuIH6ctJEvMqxmgYGRLtdyig=
X-Received: by 2002:a17:906:9c82:b0:6df:c5f0:d456 with SMTP id
 fj2-20020a1709069c8200b006dfc5f0d456mr2427716ejc.287.1660840183992; Thu, 18
 Aug 2022 09:29:43 -0700 (PDT)
MIME-Version: 1.0
From:   Kyle Rose <krose@krose.org>
Date:   Thu, 18 Aug 2022 12:29:33 -0400
Message-ID: <CAJU8_nU2Yb1yR7j8zMEnF63Lszbu8MVbePWsuwG2_mimU9iwOg@mail.gmail.com>
Subject: ULA and privacy addressing
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My site advertises two IPv6 prefixes to clients: one ULA (static) and
one GUA (in provider-owned space). I would like to by-default enable
privacy addresses for GUA prefixes, but not for ULA prefixes. The main
reason is that long-lived connections (think: SSH) within the LAN
should not stop working when a temporary address has expired. Since
privacy concerns are generally moot for ULA-sourced connections, it
seems like there's no downside.

RFC 4941 predicted the need for this kind of usage pattern:

q( Additionally, sites might wish to selectively enable or disable the
   use of temporary addresses for some prefixes.  For example, a site
   might wish to disable temporary address generation for "Unique local"
   [ULA] prefixes while still generating temporary addresses for all
   other global prefixes.  Another site might wish to enable temporary
   address generation only for the prefixes 2001::/16 and 2002::/16,
   while disabling it for all other prefixes.  To support this behavior,
   implementations SHOULD provide a way to enable and disable generation
   of temporary addresses for specific prefix subranges.  This per-
   prefix setting SHOULD override the global settings on the node with
   respect to the specified prefix subranges.  Note that the pre-prefix
   setting can be applied at any granularity, and not necessarily on a
   per-subnet basis. )

Unfortunately, since router advertisement-derived addresses are always
added with IFA_F_MANAGETEMPADDR, there appears to be no way to achieve
this short of configuring ULA addresses manually on clients, rather
than via radv.

Does anyone have any opinions on the right way to implement a
configuration knob for this (i.e., one that has a chance of being
merged)? While allowing something as expressive as a list of prefixes
for which to not configure IFA_F_MANAGETEMPADDR by default would offer
the most flexibility, it might also be considered too complex for a
niche use case. A boolean knob that allows the administrator to
disable this flag for any radv-configured address in ULA space would
probably cover the overwhelming majority of real-world use cases.

(What I'd *really* like is some way for a router to recommend clients
not use privacy addressing on a particular prefix, but I am skeptical
such a thing would get through the IETF.)

Kyle
