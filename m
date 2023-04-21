Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55E06EA801
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 12:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjDUKNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 06:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjDUKNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 06:13:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A4EC169
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 03:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682071869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H+EyffiV9Qw7lAZbakrp/7Z6LW69k/KEq7WVFkocyNY=;
        b=h992CAsbgLgz8LN8HaQmPPxafxk820q/cqyBnmiROeljnQ7I5/+DPHz0gqYbjnhAuWhEtp
        XUApqFHxFOdRfvuoJrGZMD6B0A010uCtSqWlOEEyATOAQzAXnY61VfajPekH9B/L7zWVUy
        9R5fprGTbFoTS9Z3pMxSZybUXp6ct0g=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-Tewu2IbvPcOh4TUUcINBSg-1; Fri, 21 Apr 2023 06:11:08 -0400
X-MC-Unique: Tewu2IbvPcOh4TUUcINBSg-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1a94e68e8dfso2104725ad.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 03:11:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682071867; x=1684663867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H+EyffiV9Qw7lAZbakrp/7Z6LW69k/KEq7WVFkocyNY=;
        b=Cq/KiB+EDDILIaSr1LOy8XX5Fom5rzvYIf6/++rn6j9P1DQ2tn3Fd+vkkxbPNqZPEP
         lBO4sp73sbT7Zpw3gT/KdaZEnV1x7L/5/mPSqWvcUtBbJM3KwRao9mxupJ3X0wB5t8Um
         ylVSgILV7cCJvj5eenQioUsDWytCIhYYDNcUgYw6241Bub2O+Zu5XnzJawiYH7QXB14J
         ZPRIRiEr4Tvk5IZNPr/OB4kxrFZavveS4HmI1e7Omd0Z/GncqiVj0B10OJj5t7/yDeW9
         DHyuuEKXhjF9ha7NRWhL0KOn4cB1zzk7/W9TGXJKIgs+kw6Jg3gPYJXIHluL+MhxkmtZ
         tA+w==
X-Gm-Message-State: AAQBX9eamT1xGvxrXdcnym1ziwh0IRt+4mv+2Xz5mHQCq2w99iMN4Wgz
        QGKRdcGlg9PwiXnMfNB+g7I/UMGhlJLMsFdwRZOk7ks6wMdVSrDQ33gMXRJzqajIKgeuHpv2nPK
        FWXNqbUdG396l8DsJYXQMOR/sKM53fwG7P4bJ6Uy2vCo=
X-Received: by 2002:a17:902:e54e:b0:1a3:d5af:9b6f with SMTP id n14-20020a170902e54e00b001a3d5af9b6fmr4949048plf.19.1682071867032;
        Fri, 21 Apr 2023 03:11:07 -0700 (PDT)
X-Google-Smtp-Source: AKy350YrigvE5RUgowM+gNUQ2PfyGsYFIbdKQLRcA0XDgi93EEarHeGqq78mHVqdMEWi0WdrSYAjmVLRq++H6/8/OC8=
X-Received: by 2002:a17:902:e54e:b0:1a3:d5af:9b6f with SMTP id
 n14-20020a170902e54e00b001a3d5af9b6fmr4949028plf.19.1682071866676; Fri, 21
 Apr 2023 03:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230421074720.31004-1-nicolas.dichtel@6wind.com> <20230421074720.31004-3-nicolas.dichtel@6wind.com>
In-Reply-To: <20230421074720.31004-3-nicolas.dichtel@6wind.com>
From:   David Marchand <david.marchand@redhat.com>
Date:   Fri, 21 Apr 2023 12:10:55 +0200
Message-ID: <CAJFAV8wLDmcw4poETACwyHxYKw72=4dLW+G6bHEp_J5nTikGwQ@mail.gmail.com>
Subject: Re: [PATCH iproute2 v3 2/2] iplink: fix help of 'netns' arg
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        dsahern@gmail.com, Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Salut Nicolas,

On Fri, Apr 21, 2023 at 9:48=E2=80=AFAM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> 'ip link set foo netns /proc/1/ns/net' is a valid command.
> Let's update the doc accordingly.
>
> Fixes: 0dc34c7713bb ("iproute2: Add processless network namespace support=
")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Thanks for the doc update.
Reviewed-by: David Marchand <david.marchand@redhat.com>


--=20
David Marchand

