Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E316ACF43
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCFUfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjCFUfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:35:14 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB67638663;
        Mon,  6 Mar 2023 12:35:12 -0800 (PST)
Received: from fpc (unknown [10.10.165.10])
        by mail.ispras.ru (Postfix) with ESMTPSA id 035BC40737CA;
        Mon,  6 Mar 2023 20:35:09 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 035BC40737CA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1678134909;
        bh=Gyloon2JyWI+/VPxE3VCuphx+oeFf3UuTUCEJcy7RCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XX+vUgW7ltizDg++CtEqICFGCQpAZe9G50fWOmgIC8/1XcKEgPpWSyNj8umG3rGcm
         +U9tKJAu2CmcU+teaFUFySFmXoqY3yKBB0P1BOZLIWHBxGbb2Hr5KMBEvzLdokp65q
         UmfUFmEFlXerkTDU0J1QQaS/8uWgsZbqL91V1K70=
Date:   Mon, 6 Mar 2023 23:35:04 +0300
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] nfc: change order inside nfc_se_io error path
Message-ID: <20230306203504.3qg7ewfhypd3ljdt@fpc>
References: <20230304164844.133931-1-pchelkin@ispras.ru>
 <7370a80b-56f9-a858-ff05-5ba9d7206c8c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7370a80b-56f9-a858-ff05-5ba9d7206c8c@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 04:28:12PM +0100, Krzysztof Kozlowski wrote:
> On 04/03/2023 17:48, Fedor Pchelkin wrote:
> > cb_context should be freed on error paths in nfc_se_io as stated by commit
> > 25ff6f8a5a3b ("nfc: fix memory leak of se_io context in nfc_genl_se_io").
> > 
> > Make the error path in nfc_se_io unwind everything in reverse order, i.e.
> > free the cb_context after unlocking the device.
> > 
> > No functional changes intended - only adjusting to good coding practice.
> 
> I would argue that it is functional. Running code in or outside of
> critical section/locks is quite functional change.
> 

Hmm, actually, yes. I'll resend v2 with changed commit info as 'no
functional changes' statement can probably be misunderstood later.

Should this patch be backported by the way? It doesn't seem to fix any
real issue but, as you mentioned, it contains some functional changes
which may be of some importance in future.
