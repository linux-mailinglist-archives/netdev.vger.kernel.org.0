Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D78521E19D
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgGMUn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:43:27 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60009 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgGMUn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 16:43:27 -0400
Received: from cwh (fob.gandi.net [217.70.181.1])
        (Authenticated sender: wxcafe@wxcafe.net)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 3208FE0006;
        Mon, 13 Jul 2020 20:43:22 +0000 (UTC)
Message-ID: <b02575d7937188167ed711a403e6d9fa3f80e60d.camel@wxcafe.net>
Subject: Re: [PATCH v3 1/4] Simplify usbnet_cdc_update_filter
From:   =?ISO-8859-1?Q?Wxcaf=E9?= <wxcafe@wxcafe.net>
To:     Miguel =?ISO-8859-1?Q?Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>, oliver@neukum.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org
Date:   Mon, 13 Jul 2020 16:43:11 -0400
In-Reply-To: <20180701090553.7776-2-miguel@det.uvigo.gal>
References: <20180701081550.GA7048@kroah.com>
         <20180701090553.7776-1-miguel@det.uvigo.gal>
         <20180701090553.7776-2-miguel@det.uvigo.gal>
Content-Type: multipart/mixed; boundary="=-0OHbSaOm+NVziu1H+YRH"
User-Agent: Evolution 3.36.3 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-0OHbSaOm+NVziu1H+YRH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Hey,

I've encountered that same problem a few days ago, found this thread
and these (unmerged) patches, "ported" them to a more current version
of the kernel (wasn't much work, let's be honest), and I was wondering
if it would be possible to get them merged, because this is still a
problem with cdc_ncm.

Here's the three "up to date" patches (based on 5.8-rc5), they work
insofar as I'm running with them, the bug isn't there anymore (I get
ethernet multicast packets correctly), and there's no obvious bug. I'm
not a dev though, so I have no idea if these are formatted correctly,
if the patch separation is correct, or anything like that, I just think
it would be great if this could be merged into mainline!

On Sun, 2018-07-01 at 11:05 +0200, Miguel Rodríguez Pérez wrote:
> Remove some unneded varibles to make the code easier to read
> and, replace the generic usb_control_msg function for the
> more specific usbnet_write_cmd.
> 
> Signed-off-by: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>
> NACKED-BY: Oliver Neukum <oneukum@suse.com>
> ---
>  drivers/net/usb/cdc_ether.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/usb/cdc_ether.c
> b/drivers/net/usb/cdc_ether.c
> index 178b956501a7..815ed0dc18fe 100644
> --- a/drivers/net/usb/cdc_ether.c
> +++ b/drivers/net/usb/cdc_ether.c
> @@ -77,9 +77,7 @@ static const u8 mbm_guid[16] = {
>  
>  static void usbnet_cdc_update_filter(struct usbnet *dev)
>  {
> -	struct cdc_state	*info = (void *) &dev->data;
> -	struct usb_interface	*intf = info->control;
> -	struct net_device	*net = dev->net;
> +	struct net_device *net = dev->net;
>  
>  	u16 cdc_filter = USB_CDC_PACKET_TYPE_DIRECTED
>  			| USB_CDC_PACKET_TYPE_BROADCAST;
> @@ -93,16 +91,13 @@ static void usbnet_cdc_update_filter(struct
> usbnet *dev)
>  	if (!netdev_mc_empty(net) || (net->flags & IFF_ALLMULTI))
>  		cdc_filter |= USB_CDC_PACKET_TYPE_ALL_MULTICAST;
>  
> -	usb_control_msg(dev->udev,
> -			usb_sndctrlpipe(dev->udev, 0),
> +	usbnet_write_cmd(dev,
>  			USB_CDC_SET_ETHERNET_PACKET_FILTER,
> -			USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> +			USB_TYPE_CLASS | USB_DIR_OUT |
> USB_RECIP_INTERFACE,
>  			cdc_filter,
> -			intf->cur_altsetting->desc.bInterfaceNumber,
> +			dev->intf->cur_altsetting-
> >desc.bInterfaceNumber,
>  			NULL,
> -			0,
> -			USB_CTRL_SET_TIMEOUT
> -		);
> +			0);
>  }
>  
>  /* probes control interface, claims data interface, collects the
> bulk
-- 
Wxcafé <wxcafe@wxcafe.net>

--=-0OHbSaOm+NVziu1H+YRH
Content-Disposition: attachment;
	filename*0=0001-net-cdc_ether-export-generic-usbnet_cdc_update_filte.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-net-cdc_ether-export-generic-usbnet_cdc_update_filte.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSBmYjRjMjQ2MzdkZTgyYTgxMzc0NjIyZDNmMmY5NjQ1MmUwZmIwN2QyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/V3hjYWY9QzM9QTk/PSA8d3hjYWZlQHd4Y2Fm
ZS5uZXQ+CkRhdGU6IE1vbiwgMTMgSnVsIDIwMjAgMTY6MTY6MTQgLTA0MDAKU3ViamVjdDogW1BB
VENIIDEvM10gbmV0OiBjZGNfZXRoZXI6IGV4cG9ydCBnZW5lcmljIHVzYm5ldF9jZGNfdXBkYXRl
X2ZpbHRlcgoKVGhpcyBtYWtlcyB0aGUgZnVuY3Rpb24gYXZhaWFibGUgdG8gb3RoZXIgZHJpdmVy
cywgbGlrZSBjZG5fbmNtLgoKT3RoZXIgZHJpdmVycyB3aWxsIHVzZSBkaWZmZXJlbnQgZGV2LT5k
YXRhIHR5cGVzLCBzbyB0aGUgZXhwb3J0ZWQKZnVuY3Rpb24gbXVzdCBub3QgdXNlIGl0OyBpbnN0
ZWFkIHRoZSBleHBvcnRlZCBmdW5jdGlvbiB0YWtlcyBhbgphZGRpdGlvbmFsIHBvaW50ZXIgdG8g
dGhlIGNvbnRyb2wgaW50ZXJmYWNlLgoKV2l0aGluIGNkY19ldGhlciB0aGUgY29udHJvbCBpbnRl
cmZhY2UgaXMgc3RpbGwgdGFrZW4gZnJvbSB0aGUgY29udHJvbApmaWVsZCBmcm9tIHN0cnVjdCBj
ZGNfc3RhdGUgc3RvcmVkIGluIGRldi0+ZGF0YS4KLS0tCiBkcml2ZXJzL25ldC91c2IvY2RjX2V0
aGVyLmMgfCAyNCArKysrKysrKysrKysrKysrLS0tLS0tLS0KIGluY2x1ZGUvbGludXgvdXNiL3Vz
Ym5ldC5oICB8ICAyICsrCiAyIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDggZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNiL2NkY19ldGhlci5jIGIvZHJp
dmVycy9uZXQvdXNiL2NkY19ldGhlci5jCmluZGV4IGE2NTc5NDNjOWYwMS4uYjIwMWFkYzg4NWY2
IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC91c2IvY2RjX2V0aGVyLmMKKysrIGIvZHJpdmVycy9u
ZXQvdXNiL2NkY19ldGhlci5jCkBAIC02MywxMCArNjMsOCBAQCBzdGF0aWMgY29uc3QgdTggbWJt
X2d1aWRbMTZdID0gewogCTB4YTYsIDB4MDcsIDB4YzAsIDB4ZmYsIDB4Y2IsIDB4N2UsIDB4Mzks
IDB4MmEsCiB9OwogCi1zdGF0aWMgdm9pZCB1c2JuZXRfY2RjX3VwZGF0ZV9maWx0ZXIoc3RydWN0
IHVzYm5ldCAqZGV2KQordm9pZCB1c2JuZXRfY2RjX3VwZGF0ZV9maWx0ZXIoc3RydWN0IHVzYm5l
dCAqZGV2LCBzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqY29udHJvbCkKIHsKLQlzdHJ1Y3QgY2RjX3N0
YXRlCSppbmZvID0gKHZvaWQgKikgJmRldi0+ZGF0YTsKLQlzdHJ1Y3QgdXNiX2ludGVyZmFjZQkq
aW50ZiA9IGluZm8tPmNvbnRyb2w7CiAJc3RydWN0IG5ldF9kZXZpY2UJKm5ldCA9IGRldi0+bmV0
OwogCiAJdTE2IGNkY19maWx0ZXIgPSBVU0JfQ0RDX1BBQ0tFVF9UWVBFX0RJUkVDVEVECkBAIC04
NiwxMiArODQsMjIgQEAgc3RhdGljIHZvaWQgdXNibmV0X2NkY191cGRhdGVfZmlsdGVyKHN0cnVj
dCB1c2JuZXQgKmRldikKIAkJCVVTQl9DRENfU0VUX0VUSEVSTkVUX1BBQ0tFVF9GSUxURVIsCiAJ
CQlVU0JfVFlQRV9DTEFTUyB8IFVTQl9SRUNJUF9JTlRFUkZBQ0UsCiAJCQljZGNfZmlsdGVyLAot
CQkJaW50Zi0+Y3VyX2FsdHNldHRpbmctPmRlc2MuYkludGVyZmFjZU51bWJlciwKKwkJCWNvbnRy
b2wtPmN1cl9hbHRzZXR0aW5nLT5kZXNjLmJJbnRlcmZhY2VOdW1iZXIsCiAJCQlOVUxMLAogCQkJ
MCwKIAkJCVVTQl9DVFJMX1NFVF9USU1FT1VUCiAJCSk7CiB9CitFWFBPUlRfU1lNQk9MX0dQTCh1
c2JuZXRfY2RjX3VwZGF0ZV9maWx0ZXIpOworCisvKiB0aGUgY29udHJvbCBpbnRlcmZhY2UgaXMg
bm90IGFsd2F5cyBuZWNlc3NhcmlseSB0aGUgcHJvYmVkIGludGVyZmFjZQorICogZGV2LT5pbnRm
LCBzZWUgcm5kaXMgaGFuZGxpbmcgaW4gdXNibmV0X2dlbmVyaWNfY2RjX2JpbmQuCisgKi8KK3N0
YXRpYyB2b2lkIHVzYm5ldF9jZGNfZXRoZXJfdXBkYXRlX2ZpbHRlcihzdHJ1Y3QgdXNibmV0ICpk
ZXYpIHsKKwlzdHJ1Y3QgY2RjX3N0YXRlICppbmZvID0gKHZvaWQgKikmZGV2LT5kYXRhOworCisJ
dXNibmV0X2NkY191cGRhdGVfZmlsdGVyKGRldiwgaW5mby0+Y29udHJvbCk7Cit9CiAKIC8qIHBy
b2JlcyBjb250cm9sIGludGVyZmFjZSwgY2xhaW1zIGRhdGEgaW50ZXJmYWNlLCBjb2xsZWN0cyB0
aGUgYnVsawogICogZW5kcG9pbnRzLCBhY3RpdmF0ZXMgZGF0YSBpbnRlcmZhY2UgKGlmIG5lZWRl
ZCksIG1heWJlIHNldHMgTVRVLgpAQCAtMzM2LDcgKzM0NCw3IEBAIGludCB1c2JuZXRfZXRoZXJf
Y2RjX2JpbmQoc3RydWN0IHVzYm5ldCAqZGV2LCBzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZikK
IAkgKiBkb24ndCBkbyByZXNldCBhbGwgdGhlIHdheS4gU28gdGhlIHBhY2tldCBmaWx0ZXIgc2hv
dWxkCiAJICogYmUgc2V0IHRvIGEgc2FuZSBpbml0aWFsIHZhbHVlLgogCSAqLwotCXVzYm5ldF9j
ZGNfdXBkYXRlX2ZpbHRlcihkZXYpOworCXVzYm5ldF9jZGNfZXRoZXJfdXBkYXRlX2ZpbHRlcihk
ZXYpOwogCiBiYWlsX291dDoKIAlyZXR1cm4gcnY7CkBAIC01MTQsNyArNTIyLDcgQEAgc3RhdGlj
IGNvbnN0IHN0cnVjdCBkcml2ZXJfaW5mbwljZGNfaW5mbyA9IHsKIAkuYmluZCA9CQl1c2JuZXRf
Y2RjX2JpbmQsCiAJLnVuYmluZCA9CXVzYm5ldF9jZGNfdW5iaW5kLAogCS5zdGF0dXMgPQl1c2Ju
ZXRfY2RjX3N0YXR1cywKLQkuc2V0X3J4X21vZGUgPQl1c2JuZXRfY2RjX3VwZGF0ZV9maWx0ZXIs
CisJLnNldF9yeF9tb2RlID0JdXNibmV0X2NkY19ldGhlcl91cGRhdGVfZmlsdGVyLAogCS5tYW5h
Z2VfcG93ZXIgPQl1c2JuZXRfbWFuYWdlX3Bvd2VyLAogfTsKIApAQCAtNTI0LDcgKzUzMiw3IEBA
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHJpdmVyX2luZm8JenRlX2NkY19pbmZvID0gewogCS5iaW5k
ID0JCXVzYm5ldF9jZGNfenRlX2JpbmQsCiAJLnVuYmluZCA9CXVzYm5ldF9jZGNfdW5iaW5kLAog
CS5zdGF0dXMgPQl1c2JuZXRfY2RjX3p0ZV9zdGF0dXMsCi0JLnNldF9yeF9tb2RlID0JdXNibmV0
X2NkY191cGRhdGVfZmlsdGVyLAorCS5zZXRfcnhfbW9kZSA9CXVzYm5ldF9jZGNfZXRoZXJfdXBk
YXRlX2ZpbHRlciwKIAkubWFuYWdlX3Bvd2VyID0JdXNibmV0X21hbmFnZV9wb3dlciwKIAkucnhf
Zml4dXAgPSB1c2JuZXRfY2RjX3p0ZV9yeF9maXh1cCwKIH07CkBAIC01MzUsNyArNTQzLDcgQEAg
c3RhdGljIGNvbnN0IHN0cnVjdCBkcml2ZXJfaW5mbyB3d2FuX2luZm8gPSB7CiAJLmJpbmQgPQkJ
dXNibmV0X2NkY19iaW5kLAogCS51bmJpbmQgPQl1c2JuZXRfY2RjX3VuYmluZCwKIAkuc3RhdHVz
ID0JdXNibmV0X2NkY19zdGF0dXMsCi0JLnNldF9yeF9tb2RlID0JdXNibmV0X2NkY191cGRhdGVf
ZmlsdGVyLAorCS5zZXRfcnhfbW9kZSA9CXVzYm5ldF9jZGNfZXRoZXJfdXBkYXRlX2ZpbHRlciwK
IAkubWFuYWdlX3Bvd2VyID0JdXNibmV0X21hbmFnZV9wb3dlciwKIH07CiAKZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbGludXgvdXNiL3VzYm5ldC5oIGIvaW5jbHVkZS9saW51eC91c2IvdXNibmV0LmgK
aW5kZXggYjBiZmYzMDgzMjc4Li4zODdmM2RhMDZlOWQgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGlu
dXgvdXNiL3VzYm5ldC5oCisrKyBiL2luY2x1ZGUvbGludXgvdXNiL3VzYm5ldC5oCkBAIC0yODYs
NCArMjg2LDYgQEAgZXh0ZXJuIHZvaWQgdXNibmV0X3VwZGF0ZV9tYXhfcWxlbihzdHJ1Y3QgdXNi
bmV0ICpkZXYpOwogZXh0ZXJuIHZvaWQgdXNibmV0X2dldF9zdGF0czY0KHN0cnVjdCBuZXRfZGV2
aWNlICpkZXYsCiAJCQkgICAgICAgc3RydWN0IHJ0bmxfbGlua19zdGF0czY0ICpzdGF0cyk7CiAK
K2V4dGVybiB2b2lkIHVzYm5ldF9jZGNfdXBkYXRlX2ZpbHRlcihzdHJ1Y3QgdXNibmV0ICosIHN0
cnVjdCB1c2JfaW50ZXJmYWNlICopOworCiAjZW5kaWYgLyogX19MSU5VWF9VU0JfVVNCTkVUX0gg
Ki8KLS0gCjIuMjcuMAoK


--=-0OHbSaOm+NVziu1H+YRH
Content-Disposition: attachment; filename="0002-net-usbnet-export-usbnet_set_rx_mode.patch"
Content-Type: text/x-patch; name="0002-net-usbnet-export-usbnet_set_rx_mode.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSAzMTVmN2U1NmE0YTQ5ZTljYmFmYmQ5YTg4NDQ0ZjhiMjEzNTI0ZDRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/V3hjYWY9QzM9QTk/PSA8d3hjYWZlQHd4Y2Fm
ZS5uZXQ+CkRhdGU6IE1vbiwgMTMgSnVsIDIwMjAgMTY6MTc6MjEgLTA0MDAKU3ViamVjdDogW1BB
VENIIDIvM10gbmV0OiB1c2JuZXQ6IGV4cG9ydCB1c2JuZXRfc2V0X3J4X21vZGUKCi0tLQogZHJp
dmVycy9uZXQvdXNiL3VzYm5ldC5jICAgfCAzICsrLQogaW5jbHVkZS9saW51eC91c2IvdXNibmV0
LmggfCAxICsKIDIgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNiL3VzYm5ldC5jIGIvZHJpdmVycy9uZXQvdXNi
L3VzYm5ldC5jCmluZGV4IDVlYzk3ZGVmMzUxMy4uZTQ1OTM1YTU4NTZhIDEwMDY0NAotLS0gYS9k
cml2ZXJzL25ldC91c2IvdXNibmV0LmMKKysrIGIvZHJpdmVycy9uZXQvdXNiL3VzYm5ldC5jCkBA
IC0xMTA4LDEyICsxMTA4LDEzIEBAIHN0YXRpYyB2b2lkIF9faGFuZGxlX2xpbmtfY2hhbmdlKHN0
cnVjdCB1c2JuZXQgKmRldikKIAljbGVhcl9iaXQoRVZFTlRfTElOS19DSEFOR0UsICZkZXYtPmZs
YWdzKTsKIH0KIAotc3RhdGljIHZvaWQgdXNibmV0X3NldF9yeF9tb2RlKHN0cnVjdCBuZXRfZGV2
aWNlICpuZXQpCit2b2lkIHVzYm5ldF9zZXRfcnhfbW9kZShzdHJ1Y3QgbmV0X2RldmljZSAqbmV0
KQogewogCXN0cnVjdCB1c2JuZXQJCSpkZXYgPSBuZXRkZXZfcHJpdihuZXQpOwogCiAJdXNibmV0
X2RlZmVyX2tldmVudChkZXYsIEVWRU5UX1NFVF9SWF9NT0RFKTsKIH0KK0VYUE9SVF9TWU1CT0xf
R1BMKHVzYm5ldF9zZXRfcnhfbW9kZSk7CiAKIHN0YXRpYyB2b2lkIF9faGFuZGxlX3NldF9yeF9t
b2RlKHN0cnVjdCB1c2JuZXQgKmRldikKIHsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvdXNi
L3VzYm5ldC5oIGIvaW5jbHVkZS9saW51eC91c2IvdXNibmV0LmgKaW5kZXggMzg3ZjNkYTA2ZTlk
Li40NTViNTY4ZmY0ZGQgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvdXNiL3VzYm5ldC5oCisr
KyBiL2luY2x1ZGUvbGludXgvdXNiL3VzYm5ldC5oCkBAIC0yNTQsNiArMjU0LDcgQEAgZXh0ZXJu
IGludCB1c2JuZXRfc3RvcChzdHJ1Y3QgbmV0X2RldmljZSAqbmV0KTsKIGV4dGVybiBuZXRkZXZf
dHhfdCB1c2JuZXRfc3RhcnRfeG1pdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCQkJCSAgICAgc3Ry
dWN0IG5ldF9kZXZpY2UgKm5ldCk7CiBleHRlcm4gdm9pZCB1c2JuZXRfdHhfdGltZW91dChzdHJ1
Y3QgbmV0X2RldmljZSAqbmV0LCB1bnNpZ25lZCBpbnQgdHhxdWV1ZSk7CitleHRlcm4gdm9pZCB1
c2JuZXRfc2V0X3J4X21vZGUoc3RydWN0IG5ldF9kZXZpY2UgKm5ldCk7CiBleHRlcm4gaW50IHVz
Ym5ldF9jaGFuZ2VfbXR1KHN0cnVjdCBuZXRfZGV2aWNlICpuZXQsIGludCBuZXdfbXR1KTsKIAog
ZXh0ZXJuIGludCB1c2JuZXRfZ2V0X2VuZHBvaW50cyhzdHJ1Y3QgdXNibmV0ICosIHN0cnVjdCB1
c2JfaW50ZXJmYWNlICopOwotLSAKMi4yNy4wCgo=


--=-0OHbSaOm+NVziu1H+YRH
Content-Disposition: attachment;
	filename*0=0003-net-cdc_ncm-hook-into-set_rx_mode-to-admit-multicast.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0003-net-cdc_ncm-hook-into-set_rx_mode-to-admit-multicast.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSBiNzE2YTBmYTc3N2E5ZDdkZWU4NTRiNzY4ZWZjM2ZmZjkwNzRhMmI3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/V3hjYWY9QzM9QTk/PSA8d3hjYWZlQHd4Y2Fm
ZS5uZXQ+CkRhdGU6IE1vbiwgMTMgSnVsIDIwMjAgMTY6MjA6NDEgLTA0MDAKU3ViamVjdDogW1BB
VENIIDMvM10gbmV0OiBjZGNfbmNtOiBob29rIGludG8gc2V0X3J4X21vZGUgdG8gYWRtaXQgbXVs
dGljYXN0CgpVc2UgdXNibmV0X2NkY191cGRhdGVfZmlsdGVyIGZyb20gY2RjX2V0aGVyIHRvIGFk
bWl0IGFsbCBtdWx0aWNhc3QKdHJhZmZpYyBpZiB0aGVyZSBpcyBtb3JlIHRoYW4gb25lIG11bHRp
Y2FzdCBmaWx0ZXIgY29uZmlndXJlZC4KLS0tCiBkcml2ZXJzL25ldC91c2IvY2RjX25jbS5jIHwg
MTEgKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvdXNiL2NkY19uY20uYyBiL2RyaXZlcnMvbmV0L3VzYi9jZGNfbmNt
LmMKaW5kZXggODkyOTY2OWI1ZTZkLi42ODhkN2U5ZGY0MWUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
bmV0L3VzYi9jZGNfbmNtLmMKKysrIGIvZHJpdmVycy9uZXQvdXNiL2NkY19uY20uYwpAQCAtNzky
LDYgKzc5Miw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbmV0X2RldmljZV9vcHMgY2RjX25jbV9u
ZXRkZXZfb3BzID0gewogCS5uZG9fc3RvcAkgICAgID0gdXNibmV0X3N0b3AsCiAJLm5kb19zdGFy
dF94bWl0CSAgICAgPSB1c2JuZXRfc3RhcnRfeG1pdCwKIAkubmRvX3R4X3RpbWVvdXQJICAgICA9
IHVzYm5ldF90eF90aW1lb3V0LAorCS5uZG9fc2V0X3J4X21vZGUgICAgID0gdXNibmV0X3NldF9y
eF9tb2RlLAogCS5uZG9fZ2V0X3N0YXRzNjQgICAgID0gdXNibmV0X2dldF9zdGF0czY0LAogCS5u
ZG9fY2hhbmdlX210dQkgICAgID0gY2RjX25jbV9jaGFuZ2VfbXR1LAogCS5uZG9fc2V0X21hY19h
ZGRyZXNzID0gZXRoX21hY19hZGRyLApAQCAtMTg4NSw2ICsxODg2LDEzIEBAIHN0YXRpYyB2b2lk
IGNkY19uY21fc3RhdHVzKHN0cnVjdCB1c2JuZXQgKmRldiwgc3RydWN0IHVyYiAqdXJiKQogCX0K
IH0KIAorLyogdGhlIGNvbnRyb2wgaW50ZXJmYWNlIGlzIGFsd2F5cyB0aGUgcHJvYmVkIG9uZSAq
Lworc3RhdGljIHZvaWQgdXNibmV0X2NkY19uY21fdXBkYXRlX2ZpbHRlcihzdHJ1Y3QgdXNibmV0
ICpkZXYpCit7CisJdXNibmV0X2NkY191cGRhdGVfZmlsdGVyKGRldiwgZGV2LT5pbnRmKTsKK30K
KworCiBzdGF0aWMgY29uc3Qgc3RydWN0IGRyaXZlcl9pbmZvIGNkY19uY21faW5mbyA9IHsKIAku
ZGVzY3JpcHRpb24gPSAiQ0RDIE5DTSIsCiAJLmZsYWdzID0gRkxBR19QT0lOVFRPUE9JTlQgfCBG
TEFHX05PX1NFVElOVCB8IEZMQUdfTVVMVElfUEFDS0VUCkBAIC0xODk1LDYgKzE5MDMsNyBAQCBz
dGF0aWMgY29uc3Qgc3RydWN0IGRyaXZlcl9pbmZvIGNkY19uY21faW5mbyA9IHsKIAkuc3RhdHVz
ID0gY2RjX25jbV9zdGF0dXMsCiAJLnJ4X2ZpeHVwID0gY2RjX25jbV9yeF9maXh1cCwKIAkudHhf
Zml4dXAgPSBjZGNfbmNtX3R4X2ZpeHVwLAorCS5zZXRfcnhfbW9kZSA9IHVzYm5ldF9jZGNfbmNt
X3VwZGF0ZV9maWx0ZXIsCiB9OwogCiAvKiBTYW1lIGFzIGNkY19uY21faW5mbywgYnV0IHdpdGgg
RkxBR19XV0FOICovCkBAIC0xOTA4LDYgKzE5MTcsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGRy
aXZlcl9pbmZvIHd3YW5faW5mbyA9IHsKIAkuc3RhdHVzID0gY2RjX25jbV9zdGF0dXMsCiAJLnJ4
X2ZpeHVwID0gY2RjX25jbV9yeF9maXh1cCwKIAkudHhfZml4dXAgPSBjZGNfbmNtX3R4X2ZpeHVw
LAorCS5zZXRfcnhfbW9kZSA9IHVzYm5ldF9jZGNfbmNtX3VwZGF0ZV9maWx0ZXIsCiB9OwogCiAv
KiBTYW1lIGFzIHd3YW5faW5mbywgYnV0IHdpdGggRkxBR19OT0FSUCAgKi8KQEAgLTE5MjEsNiAr
MTkzMSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHJpdmVyX2luZm8gd3dhbl9ub2FycF9pbmZv
ID0gewogCS5zdGF0dXMgPSBjZGNfbmNtX3N0YXR1cywKIAkucnhfZml4dXAgPSBjZGNfbmNtX3J4
X2ZpeHVwLAogCS50eF9maXh1cCA9IGNkY19uY21fdHhfZml4dXAsCisJLnNldF9yeF9tb2RlID0g
dXNibmV0X2NkY19uY21fdXBkYXRlX2ZpbHRlciwKIH07CiAKIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
dXNiX2RldmljZV9pZCBjZGNfZGV2c1tdID0gewotLSAKMi4yNy4wCgo=


--=-0OHbSaOm+NVziu1H+YRH--

