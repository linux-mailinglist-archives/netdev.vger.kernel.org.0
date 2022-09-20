Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873DE5BE7B2
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbiITNy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbiITNxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:53:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA415F7E7
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663681961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NoWoAM5PjMTEyFRZiCk4injlocEaVE6iGGwKNkRRD6U=;
        b=idbPa6PAIb0MuraKu4CGhlk5F/2k4DoF1PfeT9We4pA9Kq6lhWeJJiCbKGWlHkKnggMyO8
        cdHL5acqjGzDfT3+B8G0gZHlnASH+2ON+WnjVh9YjQ8I1Mu7aBMFyq3t7Vpk3MD5G4HQpv
        sVyFMEwbauafLnQMBgvzKCJoT6WHjdQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-423-KEF5kTjLMLSCG65vFItbzA-1; Tue, 20 Sep 2022 09:52:39 -0400
X-MC-Unique: KEF5kTjLMLSCG65vFItbzA-1
Received: by mail-ed1-f70.google.com with SMTP id t13-20020a056402524d00b00452c6289448so1932083edd.17
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:52:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=NoWoAM5PjMTEyFRZiCk4injlocEaVE6iGGwKNkRRD6U=;
        b=dRY3fWB1zxF+U26AHMiQ5RZKULkzli62nGHM2G9KC6HX1P0+pWpGoxRaueLZyvYi52
         jlG3EPQeGCzqgqUyix/ZHxLOU9fvShGZ+DMtFe9I2OoywSGB2dixoHKdQghwxYFtc8YY
         XxUsOruLLtvWm/y4g93MlQZyInZlGuiGcAipZ+VITPCAMuiybRc+UVS2F1ZdSmQ8DBO4
         QniZgjR+NXsqCjbMaXOzbP5TBlF279CR2tBZNXzHE1gDLKlFv+VeE98yThn+UjkW1UF2
         /BWApMrcKh3sR2lS7sM4pD9h3QYOOr/if7C9ixTySGL4ta6jUGTA8p9OnFgdcH+XjWvT
         nyrg==
X-Gm-Message-State: ACrzQf3jL9UBh1YPOe2HexEd3tpCBtfTUXzPq8wi3mZlctcrwHeuYBtO
        eFpyGSnlXQ3ZMxq9JaE8ImwUlUTL8G87fKSbekl73YOiHDIPZgOJSCx0pcs299VZSR/iLnY6OFy
        tfDh+mqFtoteseScu
X-Received: by 2002:a17:907:849:b0:77a:34b6:a23 with SMTP id ww9-20020a170907084900b0077a34b60a23mr16649681ejb.458.1663681958636;
        Tue, 20 Sep 2022 06:52:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7fPq/2Ix1yOlX2iX7qWVpJH3KNpOSVLrW0QXRTX6/LI3k9RwO3Pb1x9VGRx648f8/cxRvoIw==
X-Received: by 2002:a17:907:849:b0:77a:34b6:a23 with SMTP id ww9-20020a170907084900b0077a34b60a23mr16649653ejb.458.1663681958335;
        Tue, 20 Sep 2022 06:52:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id sb18-20020a1709076d9200b0073dddffbe70sm878102ejc.224.2022.09.20.06.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 06:52:37 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1703761C33E; Tue, 20 Sep 2022 15:52:37 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vinicius.gomes@intel.com, stephen@networkplumber.org,
        shuah@kernel.org, victor@mojatatu.com
Cc:     zhijianx.li@intel.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com, shaozhengchao@huawei.com
Subject: Re: [PATCH net-next,v2 03/18] selftests/tc-testings: add selftests
 for cake qdisc
In-Reply-To: <20220917050304.127729-1-shaozhengchao@huawei.com>
References: <20220917050304.127729-1-shaozhengchao@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 20 Sep 2022 15:52:37 +0200
Message-ID: <87r106w3tm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao <shaozhengchao@huawei.com> writes:

> Test 1212: Create CAKE with default setting
> Test 3281: Create CAKE with bandwidth limit
> Test c940: Create CAKE with autorate-ingress flag
> Test 2310: Create CAKE with rtt time
> Test 2385: Create CAKE with besteffort flag
> Test a032: Create CAKE with diffserv8 flag
> Test 2349: Create CAKE with diffserv4 flag
> Test 8472: Create CAKE with flowblind flag
> Test 2341: Create CAKE with dsthost and nat flag
> Test 5134: Create CAKE with wash flag
> Test 2302: Create CAKE with flowblind and no-split-gso flag
> Test 0768: Create CAKE with dual-srchost and ack-filter flag
> Test 0238: Create CAKE with dual-dsthost and ack-filter-aggressive flag
> Test 6572: Create CAKE with memlimit and ptm flag
> Test 2436: Create CAKE with fwmark and atm flag
> Test 3984: Create CAKE with overhead and mpu
> Test 5421: Create CAKE with conservative and ingress flag
> Test 6854: Delete CAKE with conservative and ingress flag
> Test 2342: Replace CAKE with mpu
> Test 2313: Change CAKE with mpu
> Test 4365: Show CAKE class
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

The subject prefix is misspelled for all the test patches (should be
selftests/tc-testing without the last 's').

Also, v2 of the series wasn't properly threaded for some reason, which
makes it harder to apply as a whole.

Other than those nits, for this patch:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

