Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D8A6AAB33
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 17:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjCDQou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 11:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCDQos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 11:44:48 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79291D91D;
        Sat,  4 Mar 2023 08:44:46 -0800 (PST)
Received: from fpc (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id ABB2440D403D;
        Sat,  4 Mar 2023 16:44:41 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru ABB2440D403D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1677948281;
        bh=jcmKiCU0jmyrYOYrLrsgDPTx2wBsRzFp5MKu8c+hVHk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MI2jz4XJm/ZNcsUUaGrdbdx4bCXFTXbL33DvK+t+kS0jFyXByyzsS1XUHv25LChud
         R9NPq61ahRSYOLqHTVBXwnAAA0aFoyK1etUT3uRlzyrL5Mfc1ZpoOaETYZEJQfTTRf
         gKct0HMP7uyR6P3DoVXANen0l+VOQ3VZgvDQMTwQ=
Date:   Sat, 4 Mar 2023 19:44:36 +0300
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guenter Roeck <groeck@google.com>,
        Martin Faltesek <mfaltesek@google.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Samuel Ortiz <sameo@linux.intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] nfc: fix memory leak of se_io context in nfc_genl_se_io
Message-ID: <20230304164436.w57r7rwt26vnperl@fpc>
References: <20230225105614.379382-1-pchelkin@ispras.ru>
 <20230227112359.6df702e3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227112359.6df702e3@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 11:23:59AM -0800, Jakub Kicinski wrote:
> FWIW this patch has already been applied, please send the next changes
> on top:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=25ff6f8a5a3b8dc48e8abda6f013e8cc4b14ffea

Okay.

On Mon, Feb 27, 2023 at 11:08:54AM +0100, Krzysztof Kozlowski wrote:
> kfree could be after device_unlock. Although se_io() will free it with
> lock held, but error paths usually unwind everything in reverse order
> LIFO, so first unlock then kfree.

Then, based on our dicsussion with Krzysztof, I'll send the patch
adjusting the order in the error path.
