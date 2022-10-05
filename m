Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54425F5B31
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 22:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiJEUpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 16:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiJEUo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 16:44:59 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887FF2251A
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 13:44:57 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-132af5e5543so14490fac.8
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 13:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=HxKDra6grJcWD9CqHYMkRMp+vE+Qyi1aeN+LauRdjq4=;
        b=u+3ecqY1nx8e0ZshkkP0b2uySRbILkUIxFh5s8rISRBxLuj+MR/2ZUi8TOHp5CF/Tr
         WPR4yfgljwIagRkXG/TsSYmI0tpFdS/hmQ5YMPdpFd3uuF/XG9J05L5Noy3meoMir+L3
         uG76c/pzEEv9RHioeJu4MpzaFUKCX1ZOAHBlXVO+Tld09SRP/dczI+R7dPni7/MjQMuA
         qaDOF1yTATVwCXHaxCt1o3W2y8Go/aAPcYRvIdp4IXubdf66GBxsYbiMgQeuklJVpCJJ
         ereRKliPGfQX3ack9O5tbzUb4nRdq3o+pRpzhhqY5A0V7RWzWPaqQrjgPv/aHOVcCceP
         hkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=HxKDra6grJcWD9CqHYMkRMp+vE+Qyi1aeN+LauRdjq4=;
        b=WcKXfOimQMwAD323jXcrIU2jbtTT6FTzwm7naFC9gWCqnz8Tf3btqCq4bGAMvdmtPZ
         pKM0rUQbAK01YaIre1WCTRgOLTh9qSXc576NlkV6dQwFP2ials6GvQSP1DGpkC6zyuBX
         vzIIdnWlMSJRMSzTGPwORVLg8ssveC6EmRzegRvroMT608ZElE7+n4VFz6JKTst/jbvW
         jaTXcR4RTzdwqkyeh/eA+dtNfvDltih0+L0tUYdD6TGu/zu6R2+2fpPrUQwx5wfpyFa7
         VHR8myNnLisvwNfnBAwUPm0YM64/SFacTtfazxPHgiE2PFCow4NXTnbFnLXTPulh17Oy
         Qv9A==
X-Gm-Message-State: ACrzQf2QEux3Qaby0dlSMlWrzmRLNmZOXBWTEKUmKWXgTPYxy5U3M/jR
        q8zOeIWax2Pj/6rsc9Hl+JSK+HIRVz+8khZQ0Q9e
X-Google-Smtp-Source: AMsMyM7oCOUKqnFgeWu0J+edPTN5UWcgccxor+gfSCZhi7qgSbllRBCRaxT4WOKCYdwJzSmzf1A0EjK3mntCtiWcFB0=
X-Received: by 2002:a05:6870:a916:b0:131:9361:116a with SMTP id
 eq22-20020a056870a91600b001319361116amr812898oab.172.1665002696779; Wed, 05
 Oct 2022 13:44:56 -0700 (PDT)
MIME-Version: 1.0
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 5 Oct 2022 16:44:46 -0400
Message-ID: <CAHC9VhTGE1cf_WtDn4aDUY=E-m--4iZXWiNTwPZrP9AVoq17cw@mail.gmail.com>
Subject: SO_PEERSEC protections in sk_getsockopt()?
To:     Martin KaFai Lau <martin.lau@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

In commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
sockptr_t argument") I see you wrapped the getsockopt value/len
pointers with sockptr_t and in the SO_PEERSEC case you pass the
sockptr_t:user field to avoid having to update the LSM hook and
implementations.  I think that's fine, especially as you note that
eBPF does not support fetching the SO_PEERSEC information, but I think
it would be good to harden this case to prevent someone from calling
sk_getsockopt(SO_PEERSEC) with kernel pointers.  What do you think of
something like this?

  static int sk_getsockopt(...)
  {
    /* ... */
    case SO_PEERSEC:
      if (optval.is_kernel || optlen.is_kernel)
        return -EINVAL;
      return security_socket_getpeersec_stream(...);
    /* ... */
  }

-- 
paul-moore.com
