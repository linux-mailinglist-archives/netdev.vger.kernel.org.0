Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3B0680DED
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbjA3MlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235959AbjA3MlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:41:14 -0500
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Jan 2023 04:41:10 PST
Received: from www530.your-server.de (www530.your-server.de [188.40.30.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA9F1DB93;
        Mon, 30 Jan 2023 04:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=geanix.com;
        s=default2211; h=Content-Type:MIME-Version:Message-ID:In-Reply-To:Date:
        References:Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=WMviF2Uftt9vbt5ykM/ipziMlufm0Sdyvjcbso1WflM=; b=TnxdE7pk8vryZC8boR4sFxjH3H
        tdcW4rybn5CWu+T6PVRXRDtpl6Gc/pkqDRvpLmk/ambaDi2B5b64B1mtw7H3dkOPYttSMFxdSav1p
        kBhA85o7PHkZLj+GmSfn00oKS618xKH/RfYm7qlzlX3L3Mz6Rr7kZrSX/iZNT3NG+PcVK50SVh1sE
        ekjR0BHilHPBjS7TfKp8p7maTj08wik9nWxa8eXv2m2Ji4mlzMCoHn9dBq3GF9PCaLEkMKOVY+E+C
        i0LznAFveeE3kiAdUmlD5W+pErR8h/InInMEOXf/fm7mr5CmQzfkjc0F4H5wpDeo+gffjabcNiIbr
        juV/4tNg==;
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www530.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <esben@geanix.com>)
        id 1pMTTA-00099K-7L; Mon, 30 Jan 2023 13:41:08 +0100
Received: from [80.62.117.235] (helo=localhost)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <esben@geanix.com>)
        id 1pMTTA-000Crk-8t; Mon, 30 Jan 2023 13:41:08 +0100
From:   esben@geanix.com
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jonas Suhr Christensen <jsc@umbraculum.org>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: ll_temac: improve reset of buffer on dma mapping
References: <20230126101607.88407-1-jsc@umbraculum.org>
        <20230126101607.88407-2-jsc@umbraculum.org>
        <20230127231322.08b75b36@kernel.org>
Date:   Mon, 30 Jan 2023 13:40:56 +0100
In-Reply-To: <20230127231322.08b75b36@kernel.org> (Jakub Kicinski's message of
        "Fri, 27 Jan 2023 23:13:22 -0800")
Message-ID: <87edrc8aav.fsf@geanix.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Authenticated-Sender: esben@geanix.com
X-Virus-Scanned: Clear (ClamAV 0.103.7/26797/Mon Jan 30 09:24:58 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 26 Jan 2023 11:16:07 +0100 Jonas Suhr Christensen wrote:
>> Free buffer and set pointer to null on dma mapping error.
>
> Why? I don't see a leak. You should provide motivation in the commit
> message.

I don't think there is a leak.  But if one of the dma_map_single() calls
in temac_dma_bd_init() fails, the error handling calls into
temac_dma_bd_release(), which will then call dma_unmap_single() on the
address that failed to be mapped.

Can we be sure that doing so is always safe?  If not, this change
ensures that we only unmap buffers that were succesfully mapped.

/Esben
