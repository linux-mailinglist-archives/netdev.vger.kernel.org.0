Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F006536BBD
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 10:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbiE1Iyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 04:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiE1Iyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 04:54:38 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCAF38A
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 01:54:38 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id b4so6881201iog.11
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 01:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=RXEb6/bha+HR+sX7wRYT20ImFFJiq/hIyqqizsDnzVE=;
        b=QYcZKUUn1C1z7yo2m1gFNwnZ1/gv2XrYCNd05BC0DYeSb47PK68vWN5vOUNniVy+I4
         fLwz35nOuIyIf5RRvWkp/RViQn5Spe/9Qx54tZjKhe1nNF0aJ2JpMUYWsDtYl2w9fI8s
         RVr/pU8zwmUoPmUxiradvsSqyMVVe9HbdXSJdtWWYtV9uVuIZZU4pkWbutPIo23cbE/B
         zLd+55qVEjbMBjjepNgn5zp2sXK2LgyHsfWLt/CzZ9Zo2ytUjikTKuGNLhReGzpiGxk1
         Ig3JWmJRuU/e/gxkXLHvhQwVccYkf984aKhRE+h4FdAC1JN6ySy+p1+t2JNun6QovHBz
         WGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=RXEb6/bha+HR+sX7wRYT20ImFFJiq/hIyqqizsDnzVE=;
        b=YVLf/Q+pHNvZxihYuPB2r3fCBlg0krSMYfb8+Tiyfg8HHvBRsOPJlBqO0bNf/g+BFD
         UvM1YPrg6aS/iqxZeQvNW3dNQPVPbm5KC0PQ4HSDKiznOaljxErhX7SWw/OzCBloDKSd
         BQi9+l1Vop3w1tsZop1qxeL5wI3A1qHYozRsXB8tdJOD3aFIBJl7PvmIANkeRvS9pmhk
         547a8EUxitdZFVeFa8spjkfDvJ2jNcZzQnt4DsGVqik2IV78PiMejgLqB1Jd8HPDB5Nl
         smPFitSDDvuqo5t7+ZkCqlkQnKPwSIQ4+yLZMvPS85wYkGr2/GZVvELODgEZjr/pPUL8
         Ekwg==
X-Gm-Message-State: AOAM532FfRm30SfBX3mZJ5GKUlOoo2QZhZree+1m/MkrKn06gRg0CV5C
        SsTZOvzzJBJrAvPTnTnSLwQT9z1iKlrdygIfR9C3M++Q7rxkdn7KF7M=
X-Google-Smtp-Source: ABdhPJzRy3bdDHRRvykAhMeS2BG4jALXaK7kZ2NIUfchCnzXHoZg4o7hKM+0SKg+XzWYIodiNN3Pn/t6XJwju2Lmlb4=
X-Received: by 2002:a05:6638:2581:b0:330:b843:5543 with SMTP id
 s1-20020a056638258100b00330b8435543mr7365729jat.198.1653728077146; Sat, 28
 May 2022 01:54:37 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Sat, 28 May 2022 01:54:25 -0700
Message-ID: <CANP3RGcW6DWei2bXrAQn8B4Uf0ggx_MgEfVyX_D7AaYZcYOchQ@mail.gmail.com>
Subject: 5.18 breaks Android net test PFKEY AddSA test case
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Benedict Wong <benedictwong@google.com>,
        Yan Yan <evitayan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've not gotten to the bottom of the root cause, since I'm hoping
someone will know off the top of their head,
why this might now be broken...

##### ./pf_key_test.py (13/25)

E
======================================================================
ERROR: testAddDelSa (__main__.PfKeyTest)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "./pf_key_test.py", line 42, in testAddDelSa
    pf_key.SADB_X_AALG_SHA2_256HMAC, ENCRYPTION_KEY)
  File "/aosp-tests/net/test/pf_key.py", line 254, in AddSa
    self.SendAndRecv(msg, self.PackPfKeyExtensions(extlist))
  File "/aosp-tests/net/test/pf_key.py", line 218, in SendAndRecv
    return self.Recv()
  File "/aosp-tests/net/test/pf_key.py", line 208, in Recv
    raise OSError(msg.errno, os.strerror(msg.errno))
OSError: [Errno 3] No such process

The failure is at
  https://cs.android.com/android/platform/superproject/+/master:kernel/tests/net/test/pf_key_test.py;l=42
ie.

ENCRYPTION_KEY =
("308146eb3bd84b044573d60f5a5fd15957c7d4fe567a2120f35bae0f9869ec22".decode("hex"))

src4 = csocket.Sockaddr(("192.0.2.1", 0))
dst4 = csocket.Sockaddr(("192.0.2.2", 1))
self.pf_key.AddSa(src4, dst4, 0xdeadbeef, pf_key.SADB_TYPE_ESP,
pf_key.IPSEC_MODE_TRANSPORT, 54321,
pf_key.SADB_X_EALG_AESCBC, ENCRYPTION_KEY,
pf_key.SADB_X_AALG_SHA2_256HMAC, ENCRYPTION_KEY)

Thanks,
Maciej
