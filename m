Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4074005D2
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 21:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbhICTae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 15:30:34 -0400
Received: from mail-40140.protonmail.ch ([185.70.40.140]:29534 "EHLO
        mail-40140.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235684AbhICTad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 15:30:33 -0400
Date:   Fri, 03 Sep 2021 19:29:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1630697370;
        bh=IIWvAM+fUjurDtuiATc04S+qnRbLaXtjcjstHTtfjVg=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=A1ioBZl1xKdBjsUoVYbQNxJ8/vBPQLRtMqYZcOhoRHc+wk89nShld8/SEz3kgi4Im
         LoxHPXGT4vCNsniMyZOF364LhifG4mC/qNldyz81Pcb5SQ3GS5LlgHAUnvRbQ3XzWF
         oKs6tx17Bz5tLPRWKibbawH6O5a1WMhmshpayBsA=
To:     dan.carpenter@oracle.com
From:   Yassine Oudjana <y.oudjana@protonmail.com>
Cc:     bjorn.andersson@linaro.org, butterflyhuangxx@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-msm@vger.kernel.org, loic.poulain@linaro.org,
        mani@kernel.org, netdev@vger.kernel.org
Reply-To: Yassine Oudjana <y.oudjana@protonmail.com>
Subject: Re: [PATCH v2 net] net: qrtr: make checks in qrtr_endpoint_post() stricter
Message-ID: <S4IVYQ.R543O8OZ1IFR3@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 11:37:17 +0300 Dan Carpenter wrote:
 > These checks are still not strict enough. The main problem is that if
 > "cb->type =3D=3D QRTR_TYPE_NEW_SERVER" is true then "len - hdrlen" is
 > guaranteed to be 4 but we need to be at least 16 bytes. In fact, we
 > can reject everything smaller than sizeof(*pkt) which is 20 bytes.
 >
 > Also I don't like the ALIGN(size, 4). It's better to just insist that
 > data is needs to be aligned at the start.
 >
 > Fixes: 0baa99ee353c ("net: qrtr: Allow non-immediate node routing")
 > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
 > ---
 > v2: Fix a % vs & bug. Thanks, butt3rflyh4ck!
 >
 > net/qrtr/qrtr.c | 8 ++++++--
 > 1 file changed, 6 insertions(+), 2 deletions(-)
 >
 > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
 > index b8508e35d20e..dbb647f5481b 100644
 > --- a/net/qrtr/qrtr.c
 > +++ b/net/qrtr/qrtr.c
 > @@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep,=20
const void *data, size_t len)
 > goto err;
 > }
 >
 > - if (!size || len !=3D ALIGN(size, 4) + hdrlen)
 > + if (!size || size & 3 || len !=3D size + hdrlen)
 > goto err;
 >
 > if (cb->dst_port !=3D QRTR_PORT_CTRL && cb->type !=3D QRTR_TYPE_DATA &&
 > @@ -506,8 +506,12 @@ int qrtr_endpoint_post(struct qrtr_endpoint=20
*ep, const void *data, size_t len)
 >
 > if (cb->type =3D=3D QRTR_TYPE_NEW_SERVER) {
 > /* Remote node endpoint can bridge other distant nodes */
 > - const struct qrtr_ctrl_pkt *pkt =3D data + hdrlen;
 > + const struct qrtr_ctrl_pkt *pkt;
 >
 > + if (size < sizeof(*pkt))
 > + goto err;
 > +
 > + pkt =3D data + hdrlen;
 > qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
 > }
 >
 > --
 > 2.20.1
 >

This is crashing MSM8996. I get these messages (dmesg | grep=20
remoteproc):

[ 11.677216] qcom-q6v5-mss 2080000.remoteproc: supply pll not found,=20
using dummy regulator
[ 11.701423] qcom_q6v5_pas 1c00000.remoteproc: supply cx not found,=20
using dummy regulator
[ 11.716475] qcom_q6v5_pas 1c00000.remoteproc: supply px not found,=20
using dummy regulator
[ 11.724481] remoteproc remoteproc0: 2080000.remoteproc is available
[ 11.747772] remoteproc remoteproc1: 1c00000.remoteproc is available
[ 11.762163] qcom_q6v5_pas 9300000.remoteproc: supply cx not found,=20
using dummy regulator
[ 11.778599] qcom_q6v5_pas 9300000.remoteproc: supply px not found,=20
using dummy regulator
[ 11.785288] remoteproc remoteproc2: 9300000.remoteproc is available
[ 11.786574] remoteproc remoteproc1: powering up 1c00000.remoteproc
[ 11.791908] remoteproc remoteproc1: Booting fw image=20
qcom/msm8996/scorpio/slpi.mbn, size 3921212
[ 11.870859] remoteproc remoteproc2: powering up 9300000.remoteproc
[ 11.873980] remoteproc remoteproc2: Booting fw image=20
qcom/msm8996/scorpio/adsp.mbn, size 12264177
[ 11.922394] remoteproc remoteproc1: remote processor=20
1c00000.remoteproc is now up
[ 12.036379] qcom_smd_qrtr remoteproc1:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 12.039457] qcom_smd_qrtr remoteproc1:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 12.112448] qcom_smd_qrtr remoteproc2:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 13.015132] qcom,apr remoteproc2:smd-edge.apr_audio_svc.-1.-1: Adding=20
APR dev: aprsvc:q6core:4:3
[ 13.019159] qcom,apr remoteproc2:smd-edge.apr_audio_svc.-1.-1: Adding=20
APR dev: aprsvc:q6afe:4:4
[ 13.028870] qcom,apr remoteproc2:smd-edge.apr_audio_svc.-1.-1: Adding=20
APR dev: aprsvc:q6asm:4:7
[ 13.031606] qcom,apr remoteproc2:smd-edge.apr_audio_svc.-1.-1: Adding=20
APR dev: aprsvc:q6adm:4:8
[ 13.214501] q6asm-dai 9300000.remoteproc:smd-edge:apr:q6asm:dais:=20
Adding to iommu group 3
[ 13.994777] remoteproc remoteproc0: powering up 2080000.remoteproc
[ 13.999669] remoteproc remoteproc0: Booting fw image=20
qcom/msm8996/scorpio/mba.mbn, size 213888
[ 14.247034] qcom_smd_qrtr remoteproc1:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 14.247298] qcom_smd_qrtr remoteproc1:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 17.118806] qcom_q6v5_pas 1c00000.remoteproc: timeout waiting for=20
subsystem event response
[ 17.119496] qcom_smd_qrtr remoteproc2:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 17.119556] qcom_smd_qrtr remoteproc2:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 19.422732] qcom_q6v5_pas 1c00000.remoteproc: timeout waiting for=20
subsystem event response
[ 19.423388] qcom_smd_qrtr remoteproc2:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 19.423453] qcom_smd_qrtr remoteproc2:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 22.238725] qcom_q6v5_pas 9300000.remoteproc: timeout waiting for=20
subsystem event response
[ 24.542706] qcom_q6v5_pas 9300000.remoteproc: timeout waiting for=20
subsystem event response
[ 24.543468] qcom_smd_qrtr remoteproc2:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 24.543524] qcom_smd_qrtr remoteproc2:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 24.658698] qcom-q6v5-mss 2080000.remoteproc: MBA booted without debug=20
policy, loading mpss
[ 25.994603] qcom_smd_qrtr remoteproc0:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 29.662816] qcom_q6v5_pas 9300000.remoteproc: timeout waiting for=20
subsystem event response
[ 29.662922] remoteproc remoteproc2: remote processor=20
9300000.remoteproc is now up
[ 29.665429] qcom_smd_qrtr remoteproc1:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 29.665645] qcom_smd_qrtr remoteproc1:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 34.782737] qcom_q6v5_pas 1c00000.remoteproc: timeout waiting for=20
subsystem event response
[ 34.783369] qcom_smd_qrtr remoteproc2:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 34.783526] qcom_smd_qrtr remoteproc2:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 39.902789] qcom_q6v5_pas 9300000.remoteproc: timeout waiting for=20
subsystem event response
[ 39.903057] qcom_smd_qrtr remoteproc0:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 39.903131] qcom_smd_qrtr remoteproc0:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 45.022691] qcom-q6v5-mss 2080000.remoteproc: timeout waiting for=20
subsystem event response
[ 45.022824] qcom_smd_qrtr remoteproc0:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 45.022863] qcom_smd_qrtr remoteproc0:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 50.146792] qcom-q6v5-mss 2080000.remoteproc: timeout waiting for=20
subsystem event response
[ 50.146888] remoteproc remoteproc0: remote processor=20
2080000.remoteproc is now up
[ 66.001288] qcom-q6v5-mss 2080000.remoteproc: fatal error without=20
message
[ 66.001311] remoteproc remoteproc0: crash detected in=20
2080000.remoteproc: type fatal error
[ 66.001328] remoteproc remoteproc0: handling crash #1 in=20
2080000.remoteproc
[ 66.001334] remoteproc remoteproc0: recovering 2080000.remoteproc
[ 66.003850] qcom_smd_qrtr remoteproc1:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 66.004073] qcom_smd_qrtr remoteproc1:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 71.134780] qcom_q6v5_pas 1c00000.remoteproc: timeout waiting for=20
subsystem event response
[ 71.135455] qcom_smd_qrtr remoteproc2:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 71.135505] qcom_smd_qrtr remoteproc2:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 76.258685] qcom_q6v5_pas 9300000.remoteproc: timeout waiting for=20
subsystem event response
[ 76.261799] qcom_smd_qrtr remoteproc1:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 76.262029] qcom_smd_qrtr remoteproc1:smd-edge.IPCRTR.-1.-1: invalid=20
ipcrouter packet
[ 81.374728] qcom_q6v5_pas 1c00000.remoteproc: timeout waiting for=20
subsystem event response
[ 86.494754] qcom_q6v5_pas 9300000.remoteproc: timeout waiting for=20
subsystem event response
[ 86.494812] remoteproc remoteproc0: stopped remote processor=20
2080000.remoteproc

Then I get a last message which I wasn't able to capture above but was=20
able to see:

qcom-q6v5-mss 2080000.remoteproc: MBA booted without debug policy,=20
loading mpss

and it crashes and reboots right after this message.




