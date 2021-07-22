Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1EB3D2C1C
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 20:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhGVSGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 14:06:38 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:42080
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229556AbhGVSGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 14:06:37 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 2A2523F23B;
        Thu, 22 Jul 2021 18:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626979629;
        bh=av4zwA2qg/IApI8WkrvTH+6ZHVMbOV6Gx7+f/fxSs4I=;
        h=To:Cc:From:Subject:Message-ID:Date:MIME-Version:Content-Type;
        b=itxpjq0PldP522d6DxhxMw3jsVgnjwkZjV99w5KSZQP/g5AG6mTWoqCgfWLnA9a/l
         FTjLKxUFe6kywst+9YvjHcaVe9sYXxOBnQIt7WpofCgOMz1K4TNUU4a1sy4fKieOsw
         flSOLql4O6IQk0Op7vXs5dKt+FzmORL5rrGMFiBIit4CsZHlm3WrlnyYkIXZjztRpm
         32qq+e6dF2YPNP12Ne0fX6kZ4rjEVP09vPBxtFqdLg7mVxIy7Je4JdRz65PZ3qlw+p
         4RtyL9x8KJNteIWuoGDyMjTaNFUmSHCm220JAWnmTzn2lPamfNPki+7xKZ/KYEeRsr
         Njz5lj/sULA0g==
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: octeontx2-af: Introduce internal packet switching
Message-ID: <8fc78a8c-08cb-467a-f333-031f084e3f73@canonical.com>
Date:   Thu, 22 Jul 2021 19:47:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Static analysis of linux-next with Coverity has found a couple of
uninitialized variable issues in the following commit:

commit 23109f8dd06d0bd04c9360cf7c501c97b0ab1545
Author: Subbaraya Sundeep <sbhatta@marvell.com>
Date:   Mon Jul 19 14:29:34 2021 +0530

    octeontx2-af: Introduce internal packet switching

The analysis is as follows:

195void rvu_switch_disable(struct rvu *rvu)
196{
197        struct npc_delete_flow_req uninstall_req = { 0 };
198        struct npc_mcam_free_entry_req free_req = { 0 };
199        struct rvu_switch *rswitch = &rvu->rswitch;
200        struct rvu_hwinfo *hw = rvu->hw;

   1. var_decl: Declaring variable numvfs without initializer.

201        int pf, vf, numvfs, hwvf;
202        struct msg_rsp rsp;
203        u16 pcifunc;
204        int err;
205

   2. Condition !rswitch->used_entries, taking false branch.

206        if (!rswitch->used_entries)
207                return;
208

   3. Condition pf < hw->total_pfs, taking true branch.

209        for (pf = 1; pf < hw->total_pfs; pf++) {

   4. Condition !is_pf_cgxmapped(rvu, pf), taking false branch.

210                if (!is_pf_cgxmapped(rvu, pf))
211                        continue;
212
213                pcifunc = pf << 10;
214                err = rvu_switch_install_rx_rule(rvu, pcifunc, 0xFFF);

   5. Condition err, taking false branch.

215                if (err)
216                        dev_err(rvu->dev,
217                                "Reverting RX rule for PF%d
failed(%d)\n",
218                                pf, err);
219

   Uninitialized scalar variable (UNINIT)
   6. uninit_use: Using uninitialized value numvfs.

   Uninitialized scalar variable (UNINIT)
   9. uninit_use: Using uninitialized value hwvf.

220                for (vf = 0; vf < numvfs; vf++, hwvf++) {
221                        pcifunc = pf << 10 | ((vf + 1) & 0x3FF);
222                        err = rvu_switch_install_rx_rule(rvu,
pcifunc, 0xFFF);

   7. Condition err, taking false branch.

223                        if (err)
224                                dev_err(rvu->dev,
225                                        "Reverting RX rule for
PF%dVF%d failed(%d)\n",
226                                        pf, vf, err);
227                }

   8. Jumping back to the beginning of the loop.

228        }
229
230        uninstall_req.start = rswitch->start_entry;
231        uninstall_req.end =  rswitch->start_entry +
rswitch->used_entries - 1;
232        free_req.all = 1;
233        rvu_mbox_handler_npc_delete_flow(rvu, &uninstall_req, &rsp);
234        rvu_mbox_handler_npc_mcam_free_entry(rvu, &free_req, &rsp);
235        rswitch->used_entries = 0;
236        kfree(rswitch->entry2pcifunc);
237}

Colin
