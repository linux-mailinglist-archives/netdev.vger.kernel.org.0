Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630156AE10C
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 14:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjCGNrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 08:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjCGNqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 08:46:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646CA84F40
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 05:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678196711;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=CjSk2U3oMAFmhtNturhD3NcmwhqwU56rdcLTkQIFSg8=;
        b=GX9bzm/pCMuu4ciO7QEUGFayHVeG16XNVVMtfuV1NCD2VH76lvoc1UpdE0ev1AyXIzIoLO
        C9LF+44ZnJ3BF6rQt9osfiMsjmtindRoZRsl+MpAwN5qOMOrUFRhTjn4BP5kgLJ/0Sj1Ab
        qsgcdnj8ZQzOMa9QauKI36QJmLEXjfU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-h5hR5eD8O2uvXWN4CpUT_A-1; Tue, 07 Mar 2023 08:45:06 -0500
X-MC-Unique: h5hR5eD8O2uvXWN4CpUT_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EA28803520;
        Tue,  7 Mar 2023 13:45:05 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 61ADCC15BAD;
        Tue,  7 Mar 2023 13:45:04 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id F0CD1A80B97; Tue,  7 Mar 2023 14:45:02 +0100 (CET)
Date:   Tue, 7 Mar 2023 14:45:02 +0100
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, richardcochran@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org,
        pmenzel@molgen.mpg.de, regressions@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH] igb: revert rtnl_lock() that causes deadlock
Message-ID: <ZAc/3oVos9DBx3iR@calimero.vinschen.de>
Reply-To: intel-wired-lan@lists.osuosl.org
Mail-Followup-To: Lin Ma <linma@zju.edu.cn>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org, pmenzel@molgen.mpg.de,
        regressions@lists.linux.dev, stable@vger.kernel.org
References: <301b585a.80249.186bbe6cc50.Coremail.linma@zju.edu.cn>
 <20230307130547.31446-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230307130547.31446-1-linma@zju.edu.cn>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mar  7 21:05, Lin Ma wrote:
> The commit 6faee3d4ee8b ("igb: Add lock to avoid data race") adds
> rtnl_lock to eliminate a false data race shown below
> 
>  (FREE from device detaching)      |   (USE from netdev core)
> igb_remove                         |  igb_ndo_get_vf_config
>  igb_disable_sriov                 |  vf >= adapter->vfs_allocated_count?
>   kfree(adapter->vf_data)          |
>   adapter->vfs_allocated_count = 0 |
>                                    |    memcpy(... adapter->vf_data[vf]
> 
> The above race will never happen and the extra rtnl_lock causes deadlock
> below
> [...]
> CC: stable@vger.kernel.org
> Fixes: 6faee3d4ee8b ("igb: Add lock to avoid data race")
> Reported-by: Corinna <vinschen@redhat.com>

Thank you, but "Corinna Vinschen", please.


Thanks,
Corinna

