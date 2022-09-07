Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCF05AFDD4
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiIGHqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiIGHqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:46:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3686782870
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 00:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662536771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q3eQegbyNUNUZfQN4Vuu2Y+4sgIIke5mBIO94daHPAk=;
        b=FH8JJ1jXsEyZ935BfXuOghYkFtoF/0Hm1Cn/TAae13pLxR4tRvEk9k+SIAkZTQf6wHPw33
        mSDWZdIoRkaxbwCbSLC4NqxBVlBoMdtgGfRNdj6qggeMfN9XJuCe5VQhZM6EBsl7RKXKQy
        vDy99W7oqeKE5g0rdntK8MDXyMBt5HY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-675-AkBmksKGOlKB4yqgDYRD9A-1; Wed, 07 Sep 2022 03:46:10 -0400
X-MC-Unique: AkBmksKGOlKB4yqgDYRD9A-1
Received: by mail-wr1-f71.google.com with SMTP id c14-20020adfa30e000000b00228655c4208so2626621wrb.1
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 00:46:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=q3eQegbyNUNUZfQN4Vuu2Y+4sgIIke5mBIO94daHPAk=;
        b=4yOzAI31b/Q2SzW+qBQLkmp51AJrDJPdrUd9jRIjhxWCYABs+H3z22ug7Uv5Nf/3ab
         DcobyXyVgNGFdcJkzWQF9B9Ycqgiq/vW+SkizMLWp6zj4liiR6ceq+KvBd2NUiUv7yd/
         cF1k9XDxzZoR7eR3TSNTTZcucfW5eI1rWZLF9+X8J9r9CehFtkEJCQiJ9J4AuI5W7ZZ9
         ZIx/d11zs9Al2lduF42x+95uMfTIy1CjL3kMIR6EBPgEL3Wkf2cNCGaiXIKwHJVR83rH
         CCDJ7Yz310vhAPUxfx+LwxZZE/bl9USJlgichNiRL7Uv/dPvi3TDisEuRlIFcWqH1Pgf
         UUgw==
X-Gm-Message-State: ACgBeo2u82Yd+i8Y59kUIrmGxcR5OS7zIBmfqap+OjFA2uhzMcIpnsy7
        gKW9FL5j0VSbwFFYyXfbO5SF9XClbtO+bXbYTQmhbqk8Wd5tvugXvmR5xoIdW3wA3ZZZCfgd2Be
        A0Hnxr8zDovKsbikU
X-Received: by 2002:adf:ed81:0:b0:226:a509:14b6 with SMTP id c1-20020adfed81000000b00226a50914b6mr1211068wro.150.1662536769192;
        Wed, 07 Sep 2022 00:46:09 -0700 (PDT)
X-Google-Smtp-Source: AA6agR44JqlJBu3NM8POTUmZPOMnuC7An3N2YQMeTdJEE/AQ3Rtm8kSGa0vZZHfwxjXMROy9TOM4iQ==
X-Received: by 2002:adf:ed81:0:b0:226:a509:14b6 with SMTP id c1-20020adfed81000000b00226a50914b6mr1211058wro.150.1662536768934;
        Wed, 07 Sep 2022 00:46:08 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-69.retail.telecomitalia.it. [87.11.6.69])
        by smtp.gmail.com with ESMTPSA id e3-20020a5d5303000000b0022584e771adsm16009397wrv.113.2022.09.07.00.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 00:46:08 -0700 (PDT)
Date:   Wed, 7 Sep 2022 09:45:58 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     vdasa@vmware.com
Cc:     vbhakta@vmware.com, namit@vmware.com, bryantan@vmware.com,
        zackr@vmware.com, linux-graphics-maintainer@vmware.com,
        doshir@vmware.com, gregkh@linuxfoundation.org, davem@davemloft.net,
        pv-drivers@vmware.com, joe@perches.com, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/3] MAINTAINERS: Add a new entry for VMWARE VSOCK VMCI
 TRANSPORT DRIVER
Message-ID: <20220907074558.75v3ucll6eo66zky@sgarzare-redhat>
References: <20220906172722.19862-1-vdasa@vmware.com>
 <20220906172722.19862-4-vdasa@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220906172722.19862-4-vdasa@vmware.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 10:27:22AM -0700, vdasa@vmware.com wrote:
>From: Vishnu Dasa <vdasa@vmware.com>
>
>Add a new entry for VMWARE VSOCK VMCI TRANSPORT DRIVER in the
>MAINTAINERS file.
>
>Signed-off-by: Vishnu Dasa <vdasa@vmware.com>
>---
> MAINTAINERS | 8 ++++++++
> 1 file changed, 8 insertions(+)

Thanks for adding this entry!
Will be very useful to review vsock patches for vmci transport.

Acked-by: Stefano Garzarella <sgarzare@redhat.com>

